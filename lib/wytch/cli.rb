# frozen_string_literal: true

require "thor"

module Wytch
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path("templates", __dir__)
    end

    desc "new NAME", "Create a new Wytch site"
    def new(name)
      empty_directory(name)
      template("Gemfile.tt", "#{name}/Gemfile")
      say "Created new Wytch site in #{name}/", :green
    end
  end
end
