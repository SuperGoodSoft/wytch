# frozen_string_literal: true

require "thor"

module Wytch
  class CLI < Thor
    desc "new", "Create a new Wytch site"
    def new
      puts "Beware the wytch!"
    end
  end
end
