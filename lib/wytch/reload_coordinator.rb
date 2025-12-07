# frozen_string_literal: true

require "concurrent/atomic/read_write_lock"
require "listen"

module Wytch
  # Coordinates hot reloading of site code and content during development.
  #
  # The ReloadCoordinator watches the site code and content directories for
  # changes using the Listen gem. When files change, it marks the appropriate
  # component as dirty and reloads it on the next request.
  #
  # It uses a read-write lock to ensure thread-safe reloading while allowing
  # concurrent reads during page rendering.
  #
  # @see Wytch::SiteCodeLoaderMiddleware
  class ReloadCoordinator
    # @return [Concurrent::ReadWriteLock] lock for coordinating reloads
    attr_reader :reload_lock

    # Creates a new ReloadCoordinator and sets up file watchers.
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

    # Reloads site code and/or content if changes have been detected.
    #
    # Starts file listeners on first call. If site code has changed, reloads
    # both site code (via Zeitwerk) and content. If only content has changed,
    # reloads just the content.
    #
    # @return [void]
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
