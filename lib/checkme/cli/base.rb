# frozen_string_literal: true

require "thor"
require "dotenv"

module Checkme
  module Cli
    class Base < Thor
      def initialize(*)
        super
        @original_env = ENV.to_h.dup
        load_envs
        # initialize_commander(options_with_subcommand_class_options)
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

      def load_envs
        if (destination = options[:destination])
          Dotenv.load(".env.#{destination}", ".env")
        else
          Dotenv.load(".env")
        end
      end
    end
  end
end
