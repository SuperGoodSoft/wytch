# frozen_string_literal: true

require "concurrent/atomic/read_write_lock"
require "listen"

module Wytch
  class ReloadCoordinator
    attr_reader :reload_lock

    def initialize
      @reload_lock = Concurrent::ReadWriteLock.new

      @site_code_dirty = true
      @content_dirty = true

      @start_site_code_listener = Once.new do
        Listen.to(Wytch.site.site_code_path) do
          @site_code_dirty = true
        end.start
      end

      @start_content_listener = Once.new do
        Listen.to(Wytch.site.content_dir) do
          @content_dirty = true
        end.start
      end
    end

    def reload!
      @start_site_code_listener&.call
      @start_content_listener&.call

      return unless @site_code_dirty || @content_dirty

      reload_lock.with_write_lock do
        if @site_code_dirty
          # Site code changed: reload site code then reload content
          @site_code_dirty = false
          Wytch.site.site_code_loader.reload
          Wytch.site.load_content
        elsif @content_dirty
          # Only content changed: just reload content
          @content_dirty = false
          Wytch.site.load_content
        end
      end
    end
  end
end
