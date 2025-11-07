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

    def reload_coordinator
      @reload_coordinator ||= begin
        src_path = File.join(Dir.pwd, "src")

        ReloadCoordinator.new(
          site_code_path: src_path,
          inflections: Wytch.site.inflections
        )
      end
    end

    def app
      base_app = lambda { |env|
        path = env["PATH_INFO"]
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

      # Wrap with reloading middleware
      SiteCodeLoaderMiddleware.new(base_app, reload_coordinator)
    end
  end
end
