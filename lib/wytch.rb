# frozen_string_literal: true

require "zeitwerk"
require "phlex"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("cli" => "CLI")
loader.setup

module Wytch
  class Error < StandardError; end
end

loader.eager_load
