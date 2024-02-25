# frozen_string_literal: true

require_relative "checkme/version"

require "zeitwerk"

require 'dotenv'
Dotenv.load

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/init.rb")
loader.setup
loader.eager_load # We need all commands loaded.

require_relative 'init.rb'
module Checkme
  class Error < StandardError; end
end
