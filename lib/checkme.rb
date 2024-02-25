# frozen_string_literal: true

require_relative "checkme/version"

require "zeitwerk"

require 'dotenv'
Dotenv.load

module Checkme
  class Error < StandardError; end

  def self.stateless?
    ENV['STATELESS'] == 'true'
  end

  def self.statefull?
    !stateless?
  end
end

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/init.rb")
loader.setup
loader.eager_load # We need all commands loaded.

require_relative 'init.rb'
