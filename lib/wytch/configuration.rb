# frozen_string_literal: true

module Wytch
  class Configuration
    def self.load!
      if File.exist?(config_file = File.join(Dir.pwd, "config.rb"))
        load config_file
      else
        puts "Warning: config.rb not found in current directory"
      end
    end

    def initialize
      @inflections = {}
      @content_dir = "content"
    end

    attr_reader :inflections

    def inflect(inflections_hash)
      @inflections.merge!(inflections_hash)
    end

    attr_accessor :content_dir
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration) if block_given?
      configuration
    end

    def reset_configuration!
      @configuration = nil
    end
  end
end
