# frozen_string_literal: true

module Wytch
  class Page
    def initialize(file_path:)
      @file_path = file_path
      @metadata = {}
      @view_class = nil

      instance_eval File.read(file_path), file_path
    end

    attr_reader :metadata

    def render
      @view_class.new(self).call
    end

    def path
      relative_path = @file_path.delete_prefix("#{Wytch.configuration.content_dir}/").delete_suffix(".rb")

      if relative_path == "index"
        "/"
      else
        "/#{relative_path}"
      end
    end

    def add(helper_module)
      extend helper_module
    end

    def view(view_class)
      @view_class = view_class
    end
  end
end
