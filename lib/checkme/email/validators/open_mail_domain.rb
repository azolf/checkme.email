# frozen_string_literal: true

require "securerandom"

module Checkme
  module Email
    module Validators
      class OpenMailDomain < Validator
        def self.process(email_address)
          custom_configuration = Truemail.configuration
          custom_configuration.default_validation_type = :smtp

          domain = email_address.match(/@.*/).to_s
          random_mail = "#{SecureRandom.hex}#{domain}"

          truemail_result = Truemail.validate(random_mail, custom_configuration:)

          if truemail_result.result.success
            truemail_result.result.success = false
            truemail_result.result.errors[:open_mail_domain] =
              "This domain accept any email addresses. It just accepted #{random_mail}"
          end

          truemail_result
        end
      end
    end
  end
end
