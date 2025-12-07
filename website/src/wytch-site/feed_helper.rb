# frozen_string_literal: true

module Wytch-site
  module FeedHelper
    def path
      "/feed.xml"
    end

    def build_path
      "feed.xml"
    end

    def include_in_sitemap?
      false
    end
  end
end
