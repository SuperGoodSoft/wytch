# frozen_string_literal: true

require "rack"

module Wytch
  # Development server for Wytch sites.
  #
  # The Server provides a local development environment with:
  # - Hot reloading of site code and content
  # - Static file serving from public/
  # - Page rendering on each request
  #
  # @example Starting via CLI
  #   $ wytch server
  #   $ wytch server --port 3000 --host 0.0.0.0
  #
  # @example Starting programmatically
  #   Wytch::Server.new(port: 3000).start
  class Server
    # @return [Hash] server options (port, host)
    attr_reader :options

    # Creates a new server instance.
    #
    # @param options [Hash] server options
    # @option options [Integer] :port the port to listen on (default: 6969)
    # @option options [String] :host the host to bind to (default: "localhost")
    def initialize(options = {})
      @options = options
    end

    # Starts the development server.
    #
    # Loads the site configuration, starts file watchers for hot reloading,
    # and begins serving requests. This method blocks until the server is stopped.
    #
    # @return [void]
    def start
      ENV["RACK_ENV"] = "development"
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

    # Builds the Rack application stack.
    #
    # @return [Rack::Builder] the configured Rack app
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
