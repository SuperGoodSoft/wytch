# frozen_string_literal: true

module Wytch
  class ContentLoader
    attr_reader :content_dir

    def initialize(content_dir = "content")
      @content_dir = content_dir
    end

    def load_content
      pages = {}

      Dir.glob(File.join(content_dir, "**", "*.rb")).each do |file_path|
        route = route_from_path(file_path)
        page = load_page(file_path)
        pages[route] = page
      end

      pages
    end

    private

    def route_from_path(file_path)
      # Convert content/index.rb -> /
      # Convert content/about.rb -> /about
      # Convert content/blog/my-post.rb -> /blog/my-post
      relative_path = file_path.delete_prefix("#{content_dir}/").delete_suffix(".rb")

      if relative_path == "index"
        "/"
      else
        "/#{relative_path}"
      end
    end

    def load_page(file_path)
      page = Page.new
      page.instance_eval(File.read(file_path), file_path)
      page
    end
  end
end
