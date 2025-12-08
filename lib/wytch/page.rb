# frozen_string_literal: true

module Wytch
  # Represents a single page in a Wytch site.
  #
  # Pages are defined by Ruby content files in the content directory. Each content
  # file is evaluated in the context of a Page instance, allowing it to set metadata
  # and configure the view class.
  #
  # @example A typical content file (content/about.rb)
  #   view MySite::AboutView
  #   add MySite::PageHelpers
  #
  #   @metadata[:title] = "About Us"
  #   @metadata[:description] = "Learn more about our company"
  #
  # @example Accessing page data in a view
  #   class MySite::AboutView < Phlex::HTML
  #     def initialize(page)
  #       @page = page
  #     end
  #
  #     def view_template
  #       h1 { @page.metadata[:title] }
  #     end
  #   end
  class Page
    # Creates a new page by loading and evaluating a content file.
    #
    # @param file_path [String] path to the content file, relative to the content directory
    def initialize(file_path:)
      @file_path = file_path
      @metadata = {}
      @view_class = nil

      source_path = File.join(Wytch.site.content_dir, @file_path)

      instance_eval File.read(source_path), source_path
    end

    # @return [Hash] arbitrary metadata set by the content file
    attr_reader :metadata

    # Renders the page using its configured view class.
    #
    # @return [String] the rendered HTML
    def render
      @view_class.new(self).call
    end

    # Returns the URL path for this page.
    #
    # @return [String] the URL path (e.g., "/" for index, "/about" for about.rb)
    def path
      if virtual_path == "index"
        "/"
      else
        "/#{virtual_path}"
      end
    end

    # Returns the virtual path derived from the file path.
    #
    # @return [String] the path without directory prefix or .rb suffix
    def virtual_path
      @file_path.delete_prefix("#{Wytch.site.content_dir}/").delete_suffix(".rb")
    end

    # Returns the output file path for the built page.
    #
    # @return [String] the build path (e.g., "about/index.html")
    def build_path
      if virtual_path == "index"
        "index.html"
      else
        "#{virtual_path}/index.html"
      end
    end

    # Extends this page instance with a helper module.
    # Called from content files to add helper methods.
    #
    # @param helper_module [Module] the module to extend this page with
    # @return [void]
    #
    # @example
    #   add MySite::PostHelpers
    def add(helper_module)
      extend helper_module
    end

    # Sets the view class for rendering this page.
    # Called from content files to specify which Phlex view to use.
    #
    # @param view_class [Class] a Phlex view class that accepts the page in its initializer
    # @return [void]
    #
    # @example
    #   view MySite::PostView
    def view(view_class)
      @view_class = view_class
    end

    # Whether this page should be included in the sitemap.
    # Override in subclasses to exclude pages.
    #
    # @return [Boolean] true by default
    def include_in_sitemap?
      true
    end

    # The last modification date for sitemap generation.
    # Override in subclasses to provide actual dates.
    #
    # @return [Date, Time, nil] the last modified date, or nil if unknown
    def last_modified
      nil
    end

    # The change frequency hint for sitemap generation.
    # Override in subclasses to provide hints like "daily", "weekly", etc.
    #
    # @return [String, nil] the change frequency, or nil if unknown
    def change_frequency
      nil
    end

    # The priority hint for sitemap generation.
    # Override in subclasses to provide a value between 0.0 and 1.0.
    #
    # @return [Float, nil] the priority, or nil if unknown
    def priority
      nil
    end
  end
end
