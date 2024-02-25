# frozen_string_literal: true

require "thor"
require "dotenv"

module Checkme
  module Cli
    class Email < Base
      desc "validate", "validate an email address"
      def validate
        print_runtime do
          say "Setting up validator", :magenta

          email = options[:email]
          say "Validating email: #{email}", :magenta

          methods = options[:methods]
          methods = methods.split(",").map(&:to_sym)

          say Checkme::Email::Validator.process(email, methods, options[:skip_cache])
        end
      end
    end
  end
end
