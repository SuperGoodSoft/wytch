# frozen_string_literal: true

module Wytch
  class Configuration
    attr_reader :inflections

    def initialize
      @inflections = {}
    end

    def inflect(inflections_hash)
      @inflections.merge!(inflections_hash)
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
