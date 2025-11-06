# frozen_string_literal: true

require "thor"

module Wytch
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path("templates", __dir__)
    end

    desc "new NAME", "Create a new Wytch site"
    method_option :local, type: :boolean, default: false, desc: "Use local Wytch gem for development"
    def new(name)
      @local_wytch_path = File.expand_path("../..", __dir__) if options[:local]

      # Extract site name and create module constant
      @site_name = File.basename(name)
      @site_module = classify(@site_name)

      empty_directory(name)
      template("Gemfile.tt", "#{name}/Gemfile")
      template("config.rb.tt", "#{name}/config.rb")

      # Content directory
      empty_directory("#{name}/content")
      template("content/index.rb.tt", "#{name}/content/index.rb")

      # Src directory with namespaced code
      empty_directory("#{name}/src")
      empty_directory("#{name}/src/#{@site_name}")
      template("src/site/index_view.rb.tt", "#{name}/src/#{@site_name}/index_view.rb")
      template("src/site/html_helpers.rb.tt", "#{name}/src/#{@site_name}/html_helpers.rb")

      say "Created new Wytch site in #{name}/", :green
    end

    desc "server", "Start a development server"
    method_option :port, type: :numeric, default: 6969, aliases: "-p", desc: "Port to run the server on"
    method_option :host, type: :string, default: "localhost", aliases: "-h", desc: "Host to bind the server to"
    def server
      Server.new(options).start
    end

    desc "build", "Build the static site"
    def build
      Builder.new.build
    end

    private

    def classify(name)
      name.split("_").map(&:capitalize).join
    end
  end
end
