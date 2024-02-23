# frozen_string_literal: true

require "thor"
require "dotenv"

module Checkme
  module Cli
    class Email < Base
      desc "validate", "validate an email address"
      option :email, aliases: "-e", type: :string,
                     desc: "email address to validate"
      # option :port, aliases: "-p", type: :string, default: "2525", desc: "Smtp port"
      def validate
        print_runtime do
          say "Setting up validator", :magenta
          setup_truemail({})

          email = options[:email]
          say "Validating email: #{email}", :magenta

          say Checkme::Email::Validator.process(email)
        end
      end

    private

      def setup_truemail(params)
        Truemail.configure do |config|
          # Required parameter. Must be an existing email on behalf of which verification will be performed
          config.verifier_email = 'verifier@example.com'
        end
      end
    end
  end
end
