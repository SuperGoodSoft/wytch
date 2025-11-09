# frozen_string_literal: true

require "fileutils"

module Wytch
  class Builder
    OUTPUT_DIR = "build"

    def build
      Site.load!

      SiteCodeLoader.new(
        path: "src",
        enable_reloading: false,
        inflections: Wytch.site.inflections
      )
      pages = ContentLoader.new.load_content

      FileUtils.mkdir(OUTPUT_DIR) unless Dir.exist?(OUTPUT_DIR)

      pages.values.each do |page|
        build_path = File.join(OUTPUT_DIR, page.build_path)

        puts "Building #{page.path} → #{build_path}"

        FileUtils.mkdir_p File.dirname(build_path)

        File.write build_path, page.render
      end

      copy_public_files
    end

    private

    def copy_public_files
      return unless Dir.exist?("public")

      FileUtils.cp_r "public/.", OUTPUT_DIR, verbose: true
    end
  end
end
