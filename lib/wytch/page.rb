# frozen_string_literal: true

module Wytch
  class Page
    attr_reader :metadata, :view_class

    def initialize
      @metadata = {}
      @view_class = nil
      @helpers = []
    end

    def render
      @view_class.new(self).call
    end

    def add(helper_module_name)
      helper_module = Object.const_get(helper_module_name)
      @helpers << helper_module
      extend(helper_module)
    end

    def view(view_class_name)
      @view_class = Object.const_get(view_class_name)
    end
  end
end
