# frozen_string_literal: true

module Wytch
  class Configuration
    attr_reader :page_mappings, :content_loader

    def initialize
      @page_mappings = {}
      @content_loader = ContentLoader.new
    end

    def load_content
      @page_mappings = @content_loader.load_content
    end

    def reload_content
      load_content
    end

    # Legacy method for manual page registration
    def page(path, page_instance)
      @page_mappings[path] = page_instance
    end
  end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
      configuration
    end

    def reset_configuration!
      self.configuration = nil
    end
  end
end
