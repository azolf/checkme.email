# frozen_string_literal: true

require 'truemail'

module Checkme
  module Email
    class Validator
      METHODS = {
        regex: Validators::Regex,
        mx: Validators::Mx,
        smtp: Validators::Smtp,
        open_mail_domain: Validators::OpenMailDomain
      }

      def self.process(email, methods = METHODS.keys)
        results = {}
        methods.each do |method|
          results[method] = parsed_result(METHODS[method].process(email).result)
        end

        {
          success: results.select{ |k, v| v[:success] == false }.empty?,
          methods: results,
        }
      end

      private
        def self.parsed_result(result)
          result.to_h.slice(:success, :domain, :errors)
        end
    end
  end
end
