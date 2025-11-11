# frozen_string_literal: true

require "fileutils"

module Wytch
  class Builder
    OUTPUT_DIR = "build"

    def build
      ENV["RACK_ENV"] = "production"
      Site.load!

      Wytch.site.site_code_loader.eager_load
      Wytch.site.load_content

      FileUtils.mkdir(OUTPUT_DIR) unless Dir.exist?(OUTPUT_DIR)

      Wytch.site.pages.values.each do |page|
        build_path = File.join(OUTPUT_DIR, page.build_path)

        puts "Building #{page.path} → #{build_path}"

        FileUtils.mkdir_p File.dirname(build_path)

        File.write build_path, page.render
      end

      copy_public_files
      copy_vite_assets
    end

    private

    def copy_public_files
      return unless Dir.exist?("public")

      FileUtils.cp_r "public/.", OUTPUT_DIR, verbose: true
    end

    def copy_vite_assets
      vite_output = File.join(OUTPUT_DIR, "assets")
      return unless Dir.exist?(vite_output)

      # Vite already builds to build/assets, so assets are already in place
      puts "Vite assets ready at #{vite_output}"
    end
  end
end
