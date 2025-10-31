# frozen_string_literal: true

require "thor"

module Wytch
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path("templates", __dir__)
    end

    desc "new NAME", "Create a new Wytch site"
    def new(name)
      empty_directory(name)
      template("Gemfile.tt", "#{name}/Gemfile")
      template("config.rb.tt", "#{name}/config.rb")

      # Content directory
      empty_directory("#{name}/content")
      template("content/index.rb.tt", "#{name}/content/index.rb")

      # Views directory
      empty_directory("#{name}/views")
      template("views/index_view.rb.tt", "#{name}/views/index_view.rb")

      # Helpers directory
      empty_directory("#{name}/helpers")
      template("helpers/html_helpers.rb.tt", "#{name}/helpers/html_helpers.rb")

      say "Created new Wytch site in #{name}/", :green
    end

    desc "server", "Start a development server"
    method_option :port, type: :numeric, default: 6969, aliases: "-p", desc: "Port to run the server on"
    method_option :host, type: :string, default: "localhost", aliases: "-h", desc: "Host to bind the server to"
    def server
      Server.new(options).start
    end
  end
end
