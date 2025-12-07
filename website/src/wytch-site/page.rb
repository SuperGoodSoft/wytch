# frozen_string_literal: true

module Wytch-site
  class Page < Wytch::Page
    def blog_post?
      false
    end
  end
end
