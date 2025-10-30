# frozen_string_literal: true

require "rack"

module Wytch
  class Server
    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def start
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
      lambda { |env|
        [
          200,
          {"content-type" => "text/html"},
          ["<html><body><h1>Beware the wytch!</h1><p>Development server is running.</p></body></html>"]
        ]
      }
    end
  end
end
