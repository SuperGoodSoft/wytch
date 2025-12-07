# frozen_string_literal: true

module Wytch-site
  module SitemapHelper
    def path
      "/sitemap.xml"
    end

    def build_path
      "sitemap.xml"
    end

    def include_in_sitemap?
      false
    end
  end
end
