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

    def add(helper_module)
      extend helper_module
    end

    def view(view_class)
      @view_class = view_class
    end
  end
end
