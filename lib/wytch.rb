# frozen_string_literal: true

require "zeitwerk"
require "phlex"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("cli" => "CLI")
loader.setup

module Wytch
  class Error < StandardError; end

  class << self
    def site
      @site ||= Site.new
    end

    def configure
      yield(site) if block_given?
      site
    end

    def reset_site!
      @site = nil
    end
  end
end

loader.eager_load
