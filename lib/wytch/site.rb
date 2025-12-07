# frozen_string_literal: true

module Wytch
  # Holds the configuration and state for a Wytch site.
  #
  # The Site class is the central configuration point for Wytch. It manages
  # the content directory, site code loading, page class, and the collection
  # of all pages.
  #
  # @example Configuring a site in config.rb
  #   Wytch.configure do |site|
  #     site.page_class = "MySite::Page"
  #     site.base_url = "https://example.com"
  #     site.content_dir = "pages"  # default is "content"
  #   end
  #
  # @see Wytch.configure
  class Site
    # Loads the site configuration from config.rb in the current directory.
    #
    # @return [void]
    def self.load!
      if File.exist?(config_file = File.join(Dir.pwd, "config.rb"))
        load config_file
      else
        puts "Warning: config.rb not found in current directory"
      end
    end

    # Creates a new Site with default configuration.
    def initialize
      @inflections = {}
      @content_dir = "content"
      @site_code_path = "src"
      @page_class = "Wytch::Page"
      @pages = {}
      @base_url = nil
    end

    # @return [Hash] custom inflections for Zeitwerk autoloading
    attr_reader :inflections

    # @!attribute content_dir
    #   @return [String] directory containing content files (default: "content")
    # @!attribute site_code_path
    #   @return [String] directory containing site Ruby code (default: "src")
    # @!attribute page_class
    #   @return [String] fully qualified class name for pages (default: "Wytch::Page")
    # @!attribute pages
    #   @return [Hash{String => Page}] all loaded pages, keyed by path
    # @!attribute base_url
    #   @return [String, nil] base URL for the site (used in sitemaps, feeds, etc.)
    attr_accessor :content_dir, :site_code_path, :page_class, :pages, :base_url

    # Adds custom inflections for Zeitwerk autoloading.
    #
    # @param inflections_hash [Hash{String => String}] mapping of file names to class names
    # @return [void]
    #
    # @example
    #   site.inflect("api" => "API", "html_parser" => "HTMLParser")
    def inflect(inflections_hash)
      @inflections.merge!(inflections_hash)
    end

    # Returns the Zeitwerk loader for site code.
    #
    # The loader is configured to watch the site_code_path directory and
    # supports hot reloading during development.
    #
    # @return [Zeitwerk::Loader] the configured loader
    def site_code_loader
      @site_code_loader ||= begin
        loader = Zeitwerk::Loader.new
        loader.push_dir @site_code_path if Dir.exist?(@site_code_path)
        loader.enable_reloading
        loader.inflector.inflect(@inflections) if @inflections.any?
        loader.setup
        loader
      end
    end

    # Returns the content loader instance.
    #
    # @return [ContentLoader] the loader for content files
    def content_loader
      @content_loader ||= ContentLoader.new
    end

    # Loads all content files and populates the pages hash.
    #
    # @return [Hash{String => Page}] all loaded pages
    def load_content
      @pages = content_loader.load_content
    end
  end
end
