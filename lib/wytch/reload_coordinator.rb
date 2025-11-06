# frozen_string_literal: true

require "concurrent/atomic/read_write_lock"
require "listen"

module Wytch
  class ReloadCoordinator
    attr_reader :reload_lock, :pages

    def initialize(site_code_path:, inflections: {})
      @site_code_path = site_code_path
      @inflections = inflections
      @pages = {}
      @reload_lock = Concurrent::ReadWriteLock.new

      # Track what's dirty
      @site_code_dirty = false
      @content_dirty = false

      setup_site_code_loader
      setup_content_watching

      # Load initial content
      reload_content
    end

    def reload!
      start_listeners

      return unless @site_code_dirty || @content_dirty

      reload_lock.with_write_lock do
        if @site_code_dirty
          # Site code changed: reload site code then reload content
          @site_code_dirty = false
          @site_code_loader.reload
          reload_content
        elsif @content_dirty
          # Only content changed: just reload content
          @content_dirty = false
          reload_content
        end
      end
    end

    def eager_load
      @site_code_loader.eager_load
      reload_content
    end

    private

    def setup_site_code_loader
      @site_code_loader = Zeitwerk::Loader.new
      @site_code_loader.push_dir @site_code_path if Dir.exist?(@site_code_path)
      @site_code_loader.enable_reloading
      @site_code_loader.inflector.inflect(@inflections) if @inflections.any?
      @site_code_loader.setup
    end

    def setup_content_watching
      @start_site_code_listener = Once.new do
        Listen.to(@site_code_path) do
          @site_code_dirty = true
        end.start
      end

      @start_content_listener = Once.new do
        Listen.to(Wytch.configuration.content_dir) do
          @content_dirty = true
        end.start
      end
    end

    def start_listeners
      @start_site_code_listener&.call
      @start_content_listener&.call
    end

    def reload_content
      content_loader = ContentLoader.new
      @pages = content_loader.load_content
    end
  end
end
