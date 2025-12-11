# frozen_string_literal: true

require 'json'

module WytchSite
  class Layout < Phlex::HTML
    MANIFEST_PATH = "build/assets/.vite/manifest.json"

    def initialize(page)
      @page = page
    end

    def view_template(&block)
      doctype

      html do
        head do
          meta charset: "utf-8"
          title { @page.metadata[:title] }
          meta name: "description", content: @page.metadata[:description] if @page.metadata[:description]
          meta name: "viewport", content: "width=device-width, initial-scale=1.0"

          # Vite assets
          if ENV["RACK_ENV"] == "development"
            script src: "http://localhost:6970/@vite/client", type: "module"
            link rel: "stylesheet", href: "http://localhost:6970/assets/main.css"
            script src: "http://localhost:6970/assets/Main.res", type: "module"
          else
            link rel: "stylesheet", href: asset_path("assets/main.css")
            script src: asset_path("assets/Main.res", "assets/app.js"), type: "module"
          end
        end

        body(&block)
      end
    end

    private

    def asset_path(file_path, default_path = nil)
      "/#{asset_manifest[file_path]&.fetch("file", default_path || file_path)}"
    end

    def asset_manifest
      @asset_manifest ||=
        if File.exist?(MANIFEST_PATH)
          JSON.parse(File.read(MANIFEST_PATH))
        else
          {}
        end
    end
  end
end
