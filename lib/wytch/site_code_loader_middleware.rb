# frozen_string_literal: true

module Wytch
  # Rack middleware that triggers hot reloading before each request.
  #
  # This middleware wraps the base application and coordinates with the
  # ReloadCoordinator to ensure site code and content are reloaded when
  # files change. It acquires a read lock during request processing to
  # prevent reloads from interfering with rendering.
  #
  # @see Wytch::ReloadCoordinator
  class SiteCodeLoaderMiddleware
    # Creates a new middleware instance.
    #
    # @param app [#call] the Rack application to wrap
    # @param coordinator [ReloadCoordinator] the reload coordinator
    def initialize(app, coordinator)
      @app = app
      @coordinator = coordinator
    end

    # Handles a Rack request.
    #
    # Triggers a reload check, then processes the request while holding
    # a read lock to prevent concurrent reloads.
    #
    # @param env [Hash] the Rack environment
    # @return [Array] the Rack response tuple
    def call(env)
      @coordinator.reload!

      @coordinator.reload_lock.with_read_lock {
        @app.call(env)
      }
    end
  end
end
