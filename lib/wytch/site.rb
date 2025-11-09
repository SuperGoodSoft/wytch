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
      @site_code_path = "src"
      @pages = {}
    end

    attr_reader :inflections
    attr_accessor :content_dir, :site_code_path, :pages

    def inflect(inflections_hash)
      @inflections.merge!(inflections_hash)
    end

    def site_code_loader
      @site_code_loader ||= begin
        loader = Zeitwerk::Loader.new
        loader.push_dir @site_code_path if Dir.exist?(@site_code_path)
        loader.enable_reloading
        loader.inflector.inflect(@inflections) if @inflections.any?
        loader.setup
        loader
      end
    end

    def content_loader
      @content_loader ||= ContentLoader.new
    end

    def load_content
      @pages = content_loader.load_content
    end
  end
end
