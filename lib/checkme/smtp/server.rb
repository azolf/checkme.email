# frozen_string_literal: true

require "midi-smtp-server"

module Checkme
  module Smtp
    class Server < MidiSmtpServer::Smtpd
      attr_accessor :validation_methods

      def initialize(**args)
        self.validation_methods = args[:validation_methods]
        args.delete(:validation_methods)
        super
      end

      def on_message_data_event(ctx)
        mail = Mail.read_from_string(ctx[:message][:data])
        mail = remove_unavailable_mail_boxses(mail)

        mail.deliver!
      end

      # check the authentication
      # if any value returned, that will be used for ongoing processing
      # otherwise the original value will be used for authorization_id
      def on_auth_event(_ctx, authorization_id, authentication_id, authentication)
        if authorization_id == "" && ENV['AUTH_USERNAME'] == authentication_id && ENV['AUTH_PASSWORD'] == authentication

          return authentication_id
        end

        raise MidiSmtpServer::Smtpd535Exception
      end

      private
      def remove_unavailable_mail_boxses(mail)
        addresses =  mail.to
        addresses.each do |address|
          validate = Checkme::Email::Validator.process(address, self.validation_methods)
          addresses.delete(address) unless validate[:is_valid]
        end
        raise MidiSmtpServer::Smtpd450Exception if addresses.empty?

        mail.to = addresses

        mail
      end
    end
  end
end
