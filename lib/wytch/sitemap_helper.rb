# frozen_string_literal: true

module Wytch
  # Helper module for sitemap pages.
  #
  # This module provides methods to configure a page as a sitemap.
  # It sets the correct path, build path, and excludes the sitemap
  # itself from appearing in the sitemap.
  #
  # @example Using in a content file (content/sitemap.rb)
  #   view Wytch::SitemapView
  #   add Wytch::SitemapHelper
  module SitemapHelper
    # Returns the URL path for the sitemap.
    #
    # @return [String] "/sitemap.xml"
    def path
      "/sitemap.xml"
    end

    # Returns the build path for the sitemap.
    #
    # @return [String] "sitemap.xml"
    def build_path
      "sitemap.xml"
    end

    # Excludes the sitemap from appearing in the sitemap.
    #
    # @return [Boolean] false
    def include_in_sitemap?
      false
    end
  end
end
