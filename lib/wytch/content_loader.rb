# frozen_string_literal: true

module Wytch
  class ContentLoader
    def load_content
      pages = {}

      Dir.glob(File.join(content_dir, "**", "*.rb")).each do |file_path|
        page = load_page(file_path)
        pages[page.path] = page
      end

      pages
    end

    private

    def load_page(file_path)
      Page.new(file_path:)
    end

    def content_dir
      Wytch.configuration.content_dir
    end
  end
end
