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
      template("gitignore.tt", "#{name}/.gitignore")

      # Asset pipeline configuration
      template("package.json.tt", "#{name}/package.json")
      template("vite.config.js.tt", "#{name}/vite.config.js")
      template("rescript.json.tt", "#{name}/rescript.json")

      # Assets directory
      empty_directory("#{name}/assets")
      template("frontend/Main.res.tt", "#{name}/assets/Main.res")
      template("frontend/main.css.tt", "#{name}/assets/main.css")

      # Content directory
      empty_directory("#{name}/content")
      template("content/index.rb.tt", "#{name}/content/index.rb")
      empty_directory("#{name}/content/posts")
      template("content/posts/hello-world.rb.tt", "#{name}/content/posts/hello-world.rb")

      # Src directory with namespaced code
      empty_directory("#{name}/src")
      empty_directory("#{name}/src/#{@site_name}")
      template("src/site/page.rb.tt", "#{name}/src/#{@site_name}/page.rb")
      template("src/site/layout.rb.tt", "#{name}/src/#{@site_name}/layout.rb")
      template("src/site/home_view.rb.tt", "#{name}/src/#{@site_name}/home_view.rb")
      template("src/site/post_view.rb.tt", "#{name}/src/#{@site_name}/post_view.rb")
      template("src/site/html_helpers.rb.tt", "#{name}/src/#{@site_name}/html_helpers.rb")

      # Public directory for static assets
      empty_directory("#{name}/public")
      template("public/robots.txt.tt", "#{name}/public/robots.txt")

      say "Created new Wytch site in #{name}/", :green
      say "\nNext steps:", :green
      say "  cd #{name}"
      say "  bundle install"
      say "  npm install"
      say "\nTo start developing:"
      say "  npm run dev       # Start Vite dev server (Terminal 1)"
      say "  wytch server      # Start Wytch dev server (Terminal 2)"
      say "\nTo build for production:"
      say "  npm run build     # Build assets with Vite"
      say "  wytch build       # Build static site"
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
