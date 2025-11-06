# frozen_string_literal: true

module Wytch
  class Page
    def initialize(file_path:)
      @file_path = file_path
      @metadata = {}
      @view_class = nil

      source_path = File.join(Wytch.configuration.content_dir, @file_path)

      instance_eval File.read(source_path), source_path
    end

    attr_reader :metadata

    def render
      @view_class.new(self).call
    end

    def path
      if virtual_path == "index"
        "/"
      else
        "/#{virtual_path}"
      end
    end

    def virtual_path
      @file_path.delete_prefix("#{Wytch.configuration.content_dir}/").delete_suffix(".rb")
    end

    def build_path
      "#{virtual_path}/index.html"
    end

    def add(helper_module)
      extend helper_module
    end

    def view(view_class)
      @view_class = view_class
    end
  end
end
