# frozen_string_literal: true

require "concurrent/atomic/read_write_lock"

module Wytch
  class SiteCodeLoader
    def initialize(path:, enable_reloading:, inflections: {})
      @loader = Zeitwerk::Loader.new

      @loader.push_dir path
      @loader.enable_reloading if enable_reloading
      @loader.inflector.inflect(inflections) if inflections.any?
      @loader.setup

      @reload_lock = Concurrent::ReadWriteLock.new

      if @loader.reloading_enabled?
        require "listen"
        @start_loading = Once.new do
          Listen.to(*@loader.dirs) do
            @dirty = true
          end.start
        end
      else
        @loader.eager_load
      end
    end

    attr_reader :reload_lock

    def eager_load
      @loader.eager_load
    end

    def reload!
      @start_loading&.call

      return unless @dirty

      reload_lock.with_write_lock do
        @dirty = false
        @loader.reload
      end
    end

    def reloading_enabled?
      @loader.reloading_enabled?
    end
  end
end
