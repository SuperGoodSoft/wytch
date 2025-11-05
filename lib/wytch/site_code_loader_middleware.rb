# frozen_string_literal: true

module Wytch
  class SiteCodeLoaderMiddleware
    def initialize(app, loader)
      @app = app
      @loader = loader
    end

    def call(env)
      @loader.reload!

      @loader.reload_lock.with_read_lock {
        @app.call(env)
      }
    end
  end
end
