# frozen_string_literal: true

module Wytch
  # Generates an XML sitemap for the site.
  #
  # This view renders a sitemap.xml file listing all pages that have
  # `include_in_sitemap?` returning true.
  #
  # @example Using in a content file (content/sitemap.rb)
  #   view Wytch::SitemapView
  #   add Wytch::SitemapHelper
  class SitemapView
    # Creates a new sitemap view.
    #
    # @param page [Page] the page object (not used but required for interface)
    def initialize(page)
      @page = page
    end

    # Renders the sitemap XML.
    #
    # @return [String] XML sitemap content
    def call
      require "builder"

      xml = ::Builder::XmlMarkup.new(indent: 2)
      xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
      xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
        Wytch.site.pages.values.each do |page|
          next unless page.include_in_sitemap?
          xml.url do
            xml.loc "#{Wytch.site.base_url}#{page.path}"
            xml.lastmod page.last_modified if page.last_modified
            xml.changefreq page.change_frequency if page.change_frequency
            xml.priority page.priority if page.priority
          end
        end
      end
    end
  end
end
