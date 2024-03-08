# frozen_string_literal: true

require "thor"

module Checkme
  module Cli
    class Smtp < Base
      desc "server", "Run a smtp server"

      def server
        say "Running the SMTP server on #{options[:hosts]}", :magenta
        return unless valid_mode?(auth_mode)
        methods = options[:methods].split(",").map(&:to_sym)
        server = ::Checkme::Smtp::Server.new(**configurations)

        # save flag for Ctrl-C pressed
        flag_status_ctrl_c_pressed = false

        # try to gracefully shutdown on Ctrl-C
        trap("INT") do
          # print an empty line right after ^C
          puts
          # notify flag about Ctrl-C was pressed
          flag_status_ctrl_c_pressed = true
          # signal exit to app
          exit 0
        end

        # Output for debug
        server.logger.info("Starting MySmtpd [#{MidiSmtpServer::VERSION::STRING}|#{MidiSmtpServer::VERSION::DATE}] (Basic usage) ...")

        # setup exit code
        at_exit do
          # check to shutdown connection
          if server
            # Output for debug
            server.logger.info("Ctrl-C interrupted, exit now...") if flag_status_ctrl_c_pressed
            # info about shutdown
            server.logger.info("Shutdown MySmtpd...")
            # stop all threads and connections gracefully
            server.stop
          end
          # Output for debug
          server.logger.info("MySmtpd down!")
        end

        # Start the server
        server.start

        # Run on server forever
        server.join
      end

      private
        def auth_mode
          case options[:auth]
          when 'required'
            :AUTH_REQUIRED
          when 'forbidden'
            :AUTH_FORBIDDEN
          when 'optional'
            :AUTH_OPTIONAL
          end
        end

        def configurations
          conf = {
            hosts: options[:hosts],
            auth_mode: auth_mode,
            ports: options[:port],
            validation_methods: methods,
            max_processings: options[:processings].to_i,
          }
          conf[:max_connections] = options[:connections].to_i if options[:connections].to_i > options[:processings].to_i

          conf
        end

        def valid_mode?(auth_mode)
          say 'AUTH_USERNAME and AUTH_PASSWORD are required' and return false if ENV['AUTH_USERNAME'].nil? || ENV['AUTH_PASSWORD'].nil?

          true
        end
    end
  end
end
