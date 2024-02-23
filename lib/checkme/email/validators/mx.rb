# frozen_string_literal: true

module Checkme
  module Email
    module Validators
      class Mx < Validator
        def self.process(email_address)
          custom_configuration = Truemail.configuration
          custom_configuration.default_validation_type = :mx

          Truemail.validate(email_address, custom_configuration:)
        end
      end
    end
  end
end
