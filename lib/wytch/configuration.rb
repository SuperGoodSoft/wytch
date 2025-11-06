# frozen_string_literal: true

module Wytch
  class Configuration
    attr_reader :inflections

    def self.load!
      if File.exist?(config_file = File.join(Dir.pwd, "config.rb"))
        load config_file
      else
        puts "Warning: config.rb not found in current directory"
      end
    end

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
