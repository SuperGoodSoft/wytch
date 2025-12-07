# frozen_string_literal: true

require "zeitwerk"
require "phlex"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("cli" => "CLI")
loader.setup

# Wytch is a minimal static site generator that uses Ruby for content
# and Phlex for views.
#
# @example Basic configuration in config.rb
#   Wytch.configure do |site|
#     site.page_class = "MySite::Page"
#     site.base_url = "https://example.com"
#   end
#
# @see Wytch::Site
# @see Wytch::Page
module Wytch
  # Base error class for all Wytch errors.
  class Error < StandardError; end

  class << self
    # Returns the global site instance.
    #
    # @return [Wytch::Site] the current site configuration
    def site
      @site ||= Site.new
    end

    # Configures the global site instance.
    #
    # @yield [site] Configuration block
    # @yieldparam site [Wytch::Site] the site instance to configure
    # @return [Wytch::Site] the configured site
    #
    # @example
    #   Wytch.configure do |site|
    #     site.page_class = "MySite::Page"
    #     site.content_dir = "pages"
    #   end
    def configure
      yield(site) if block_given?
      site
    end

    # Resets the global site instance. Primarily used for testing.
    #
    # @return [void]
    def reset_site!
      @site = nil
    end
  end
end

loader.eager_load
