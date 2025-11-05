# frozen_string_literal: true

module Wytch
  class Page
    attr_reader :metadata, :content_blocks, :view_class

    def initialize
      @metadata = {}
      @content_blocks = []
      @view_class = nil
      @helpers = []
    end

    def render
      @view_class.new(self).call
    end

    # DSL methods
    def add(helper_module_name)
      helper_module = Object.const_get(helper_module_name)
      @helpers << helper_module
      extend(helper_module)
    end

    def view(view_class_name)
      @view_class = Object.const_get(view_class_name)
    end

    # Metadata methods
    def title(value)
      @metadata[:title] = value
    end

    def date(value)
      @metadata[:date] = value
    end

    def description(value)
      @metadata[:description] = value
    end

    # Content methods
    def p(text)
      @content_blocks << {type: :paragraph, text: text}
    end

    def img(src, **options)
      @content_blocks << {type: :image, src: src, **options}
    end

    def code(content, language = nil)
      @content_blocks << {type: :code, content: content, language: language}
    end

    def method_missing(name, *args, **kwargs, &block)
      # Allow arbitrary content methods (like signup_form)
      @content_blocks << {type: name, args: args, kwargs: kwargs}
    end

    def respond_to_missing?(name, include_private = false)
      true
    end
  end
end
