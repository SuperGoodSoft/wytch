# frozen_string_literal: true

module Wytch
  class SiteCodeLoaderMiddleware
    def initialize(app, coordinator)
      @app = app
      @coordinator = coordinator
    end

    def call(env)
      @coordinator.reload!

      @coordinator.reload_lock.with_read_lock {
        @app.call(env)
      }
    end
  end
end
