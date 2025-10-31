# frozen_string_literal: true

module Wytch
  class Configuration
    attr_reader :page_mappings

    def initialize
      @page_mappings = {}
      @pages_block = nil
    end

    def pages(&block)
      @pages_block = block
      reload_pages
    end

    def reload_pages
      @page_mappings.clear
      instance_eval(&@pages_block) if @pages_block
    end

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
