# frozen_string_literal: true

module Wytch-site
  module PostHelpers
    def blog_post?
      true
    end

    def content_markdown(markdown)
      @content_markdown = markdown
    end

    def content_html
      require "commonmarker"
      Commonmarker.to_html(@content_markdown || "")
    end
  end
end
