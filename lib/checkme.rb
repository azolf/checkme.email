# frozen_string_literal: true

require_relative "checkme/version"

require "zeitwerk"

require 'dotenv'
require 'erb'
require 'yaml'

Dotenv.load

module Checkme
  class Error < StandardError; end

  def self.stateless?
    ENV['STATELESS'] == 'true'
  end

  def self.statefull?
    !stateless?
  end

  def self.db_config
    YAML.safe_load(ERB.new(File.read('db/config.yml')).result, aliases: true)[ENV['APP_ENV']]
  end
end

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/init.rb")
loader.setup
loader.eager_load # We need all commands loaded.

require_relative 'init.rb'
