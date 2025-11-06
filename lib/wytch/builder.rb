# frozen_string_literal: true

require "fileutils"

module Wytch
  class Builder
    OUTPUT_DIR = "build"

    def build
      Configuration.load!

      SiteCodeLoader.new(
        path: "src",
        enable_reloading: false,
        inflections: Wytch.configuration.inflections
      )
      pages = ContentLoader.new.load_content

      FileUtils.mkdir(OUTPUT_DIR) unless Dir.exist?(OUTPUT_DIR)

      pages.each do |route, page|
        output_path = if route == "/"
          File.join(OUTPUT_DIR, "index.html")
        else
          File.join(OUTPUT_DIR, route.delete_prefix("/"), "index.html")
        end

        FileUtils.mkdir_p(File.dirname(output_path))

        File.write(output_path, page.render)
      end
    end
  end
end
