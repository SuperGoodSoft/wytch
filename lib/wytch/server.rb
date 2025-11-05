# frozen_string_literal: true

require "rack"

module Wytch
  class Server
    attr_reader :options, :site_code_loader

    def initialize(options = {})
      @options = options
    end

    def start
      load_configuration

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

    def load_configuration
      # Initialize configuration and load config.rb first to get inflections
      config_file = File.join(Dir.pwd, "config.rb")
      if File.exist?(config_file)
        load config_file
      else
        puts "Warning: config.rb not found in current directory"
      end

      # Load site code (views, helpers) using Zeitwerk with configured inflections
      src_path = File.join(Dir.pwd, "src")

      @site_code_loader = SiteCodeLoader.new(
        path: src_path,
        enable_reloading: true,
        inflections: Wytch.configuration.inflections
      )

      # Load content files
      Wytch.configuration.load_content
    end

    def app
      base_app = lambda { |env|
        path = env["PATH_INFO"]
        page = Wytch.configuration&.page_mappings&.[](path)

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
      SiteCodeLoaderMiddleware.new(base_app, site_code_loader)
    end
  end
end
