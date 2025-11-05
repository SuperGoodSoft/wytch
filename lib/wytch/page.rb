# frozen_string_literal: true

module Wytch
  class Page
    def initialize
      @metadata = {}
      @view_class = nil
    end

    attr_reader :metadata

    def load_file(file_path)
      instance_eval File.read(file_path), file_path
    end

    def render
      @view_class.new(self).call
    end

    def add(helper_module_name)
      extend resolve_constant helper_module_name
    end

    def view(view_class_name)
      @view_class = resolve_constant view_class_name
    end

    private

    def resolve_constant(name)
      Object.const_get(name)
    end
  end
end
