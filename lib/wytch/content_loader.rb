# frozen_string_literal: true

module Wytch
  # Discovers and loads content files into Page objects.
  #
  # The ContentLoader scans the content directory for Ruby files and
  # instantiates Page objects for each one. It uses the configured
  # page_class from the Site.
  #
  # @see Wytch::Site#content_dir
  # @see Wytch::Site#page_class
  class ContentLoader
    # Loads all content files and returns a hash of pages.
    #
    # Scans the content directory recursively for .rb files,
    # creates a Page instance for each, and returns them keyed by path.
    #
    # @return [Hash{String => Page}] pages keyed by their URL path
    def load_content
      pages = {}

      Dir.glob(File.join("**", "*.rb"), base: content_dir).each do |file_path|
        page = load_page(file_path)
        pages[page.path] = page
      end

      pages
    end

    private

    # Creates a Page instance from a content file.
    #
    # @param file_path [String] path to the content file, relative to content_dir
    # @return [Page] the loaded page
    def load_page(file_path)
      page_class.new(file_path:)
    end

    # Returns the configured page class.
    #
    # @return [Class] the page class to instantiate
    def page_class
      Object.const_get(Wytch.site.page_class)
    end

    # Returns the content directory path.
    #
    # @return [String] the content directory
    def content_dir
      Wytch.site.content_dir
    end
  end
end
