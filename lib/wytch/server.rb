# frozen_string_literal: true

require "rack"

module Wytch
  class Server
    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def start
      Site.load!

      require "puma"
      require "puma/server"

      port = options[:port] || 6969
      host = options[:host] || "localhost"

      puts "Starting Wytch development server on http://#{host}:#{port}"
      puts "Press Ctrl+C to stop"

      server = Puma::Server.new(app)
      server.add_tcp_listener(host, port)
      server.run.join
    end

    private

    def app
      base_app = lambda { |env|
        path = env["PATH_INFO"]

        # Otherwise try to serve a page
        page = Wytch.site.pages[path]

        if page
          body = page.render
          [
            200,
            {"content-type" => "text/html"},
            [body]
          ]
        else
          [
            404,
            {"content-type" => "text/html"},
            ["<html><body><h1>404 Not Found</h1><p>Page not found: #{path}</p></body></html>"]
          ]
        end
      }

      reload_coordinator = ReloadCoordinator.new

      Rack::Builder.new do
        use Rack::Static, urls: [""], root: "public", cascade: true

        run SiteCodeLoaderMiddleware.new(base_app, reload_coordinator)
      end
    end
  end
end
