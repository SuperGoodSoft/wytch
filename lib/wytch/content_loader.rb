# frozen_string_literal: true

module Wytch
  class ContentLoader
    def load_content
      pages = {}

      Dir.glob(File.join("**", "*.rb"), base: content_dir).each do |file_path|
        page = load_page(file_path)
        pages[page.path] = page
      end

      pages
    end

    private

    def load_page(file_path)
      page_class.new(file_path:)
    end

    def page_class
      Object.const_get(Wytch.site.page_class)
    end

    def content_dir
      Wytch.site.content_dir
    end
  end
end
