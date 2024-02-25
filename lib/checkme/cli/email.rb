# frozen_string_literal: true

require "thor"
require "dotenv"

module Checkme
  module Cli
    class Email < Base
      desc "validate", "validate an email address"
      option :email, aliases: "-e", type: :string, required: true,
                     desc: "email address to validate"
      option :methods, aliases: "-m", type: :string, default: "all",
                       desc: "Different methods to check, regex, mx, smtp, open_mail_domain"
      def validate
        print_runtime do
          say "Setting up validator", :magenta

          email = options[:email]
          say "Validating email: #{email}", :magenta

          methods = options[:methods]
          methods = if methods == "all"
                      Checkme::Email::Validator::METHODS.keys
                    else
                      methods.split(",").map(&:to_sym)
                    end

          say Checkme::Email::Validator.process(email, methods)
        end
      end
    end
  end
end
