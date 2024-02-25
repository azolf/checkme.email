# frozen_string_literal: true

require "midi-smtp-server"

module Checkme
  module Smtp
    class Server < MidiSmtpServer::Smtpd
      def on_message_data_event(ctx)
        mail = Mail.read_from_string(ctx[:message][:data])
          # delivery_method :smtp, {
          #   address: SmtpUser.first.smtp_setting.host,
          #   port: SmtpUser.first.smtp_setting.port,
          #   password: SmtpUser.first.smtp_setting.password,
          #   user_name: SmtpUser.first.smtp_setting.user,
          #   authentication: 'plain',
          #   domain: SmtpUser.first.smtp_setting.domain,
          #   enable_starttls_auto: true
          # }
        # end
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
    end
  end
end
