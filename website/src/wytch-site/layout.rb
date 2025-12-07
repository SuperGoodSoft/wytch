# frozen_string_literal: true

module Wytch-site
  class Layout < Phlex::HTML
    def initialize(page)
      @page = page
    end

    def view_template(&block)
      doctype

      html do
        head do
          title { @page.metadata[:title] }
          meta name: "description", content: @page.metadata[:description] if @page.metadata[:description]
          meta name: "viewport", content: "width=device-width, initial-scale=1.0"

          # Vite assets
          if ENV["RACK_ENV"] == "development"
            script src: "http://localhost:6970/@vite/client", type: "module"
            link rel: "stylesheet", href: "http://localhost:6970/assets/main.css"
            script src: "http://localhost:6970/assets/Main.res", type: "module"
          else
            link rel: "stylesheet", href: "/assets/main.css"
            script src: "/assets/app.js", type: "module"
          end
        end

        body(&block)
      end
    end
  end
end
