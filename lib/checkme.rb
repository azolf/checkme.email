# frozen_string_literal: true

require_relative "checkme/version"

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup
loader.eager_load # We need all commands loaded.

module Checkme
  class Error < StandardError; end
  # Your code goes here...
end
