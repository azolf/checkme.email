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

        if check_cache?(skip_cache) && Checkme::Models::Email.find_by_email(email)
          record = Checkme::Models::Email.find_by_email(email)
          return record_to_result(record)
        end

        methods.each do |method|
          results[method] = parsed_result(METHODS[method].process(email).result)
        end
        is_valid = results.none? { |_k, v| v[:success] == false }
        save_the_results(email, is_valid, results)

        {
          email: email,
          is_valid: is_valid,
          validation_result: results
        }
      end

      def self.parsed_result(result)
        result.to_h.slice(:success, :domain, :errors)
      end

      private
      def self.check_cache?(skip_cache)
        Checkme.statefull? && !skip_cache
      end

      def self.save_the_results(email, is_valid, results)
        unless Checkme.stateless?
          record = Checkme::Models::Email.where(email: email).first_or_create
          record.update(
            email: email,
            is_valid: is_valid,
            validation_result: results
          )
        end
      end

      def self.record_to_result(record)
        record.attributes.slice('email', 'is_valid', 'validation_result').symbolize_keys
      end
    end
  end
end
