# frozen_string_literal: true

require "fileutils"

module Wytch
  # Builds the static site by rendering all pages to the output directory.
  #
  # The Builder is responsible for the production build process:
  # 1. Loading site configuration and content
  # 2. Rendering each page to HTML
  # 3. Copying static files from public/
  # 4. Integrating Vite-built assets
  #
  # @example Building via CLI
  #   $ wytch build
  #
  # @example Building programmatically
  #   Wytch::Builder.new.build
  class Builder
    # @return [String] the output directory for built files
    OUTPUT_DIR = "build"

    # Builds the entire site.
    #
    # Sets RACK_ENV to "production", loads the site configuration,
    # renders all pages to HTML files, and copies static assets.
    #
    # @return [void]
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

    # Copies files from public/ to the output directory.
    #
    # @return [void]
    def copy_public_files
      return unless Dir.exist?("public")

      FileUtils.cp_r "public/.", OUTPUT_DIR, verbose: true
    end

    # Reports on Vite assets in the output directory.
    # Vite builds directly to build/assets, so no copying is needed.
    #
    # @return [void]
    def copy_vite_assets
      vite_output = File.join(OUTPUT_DIR, "assets")
      return unless Dir.exist?(vite_output)

      # Vite already builds to build/assets, so assets are already in place
      puts "Vite assets ready at #{vite_output}"
    end
  end
end
