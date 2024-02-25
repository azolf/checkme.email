# frozen_string_literal: true

require "truemail"

module Checkme
  module Email
    class Validator
      METHODS = {
        regex: Validators::Regex,
        mx: Validators::Mx,
        smtp: Validators::Smtp,
        open_mail_domain: Validators::OpenMailDomain
      }.freeze

      def self.process(email, methods = METHODS.keys, skip_cache = false)
        results = {}

        return Checkme::Models::Email.find_by_email(email) if !skip_cache && Checkme::Models::Email.find_by_email(email)

        methods.each do |method|
          results[method] = parsed_result(METHODS[method].process(email).result)
        end

        record = Checkme::Models::Email.where(email: email).first_or_create
        record.update(
          email: email,
          is_valid: results.none? { |_k, v| v[:success] == false },
          validation_result: results
        )

        record
      end

      def self.parsed_result(result)
        result.to_h.slice(:success, :domain, :errors)
      end
    end
  end
end
