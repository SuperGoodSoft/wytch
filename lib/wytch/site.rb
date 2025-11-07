# frozen_string_literal: true

module Wytch
  class Site
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
      @pages = {}
    end

    attr_reader :inflections
    attr_accessor :content_dir, :pages

    def inflect(inflections_hash)
      @inflections.merge!(inflections_hash)
    end
  end
end
