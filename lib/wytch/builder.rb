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

      pages.values.each do |page|
        build_path = File.join(OUTPUT_DIR, page.build_path)

        puts "Building #{page.path} → #{build_path}"

        FileUtils.mkdir_p File.dirname(build_path)

        File.write build_path, page.render
      end
    end
  end
end
