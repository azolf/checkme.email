# frozen_string_literal: true

require 'thor'
require 'dotenv'
require 'mail'

module Checkme
  module Cli
    class Base < Thor
      def self.exit_on_failure? = true

      def initialize(*)
        super
        @original_env = ENV.to_h.dup
      end

      private

      def print_runtime
        started_at = Time.now
        yield
        Time.now - started_at
      ensure
        runtime = Time.now - started_at
        puts "  Finished all in #{format("%.1f seconds", runtime)}"
      end
    end
  end
end
