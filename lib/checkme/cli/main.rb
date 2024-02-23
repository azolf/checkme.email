# frozen_string_literal: true

require "thor"
require "dotenv"

module Checkme
  module Cli
    class Main < Base
      def self.exit_on_failure? = true

      desc "validate", "validate an email address"
      option :email, aliases: "-e", type: :string, required: true,
                     desc: "email address to validate"
      option :methods, aliases: "-m", type: :string, default: "all",
                       desc: "Different methods to check, regex, mx, smtp, open_mail_domain"
      def validate
        invoke "checkme:cli:email:validate"
      end

      desc "server", "Run a smtp server"
      option :hosts, aliases: "-h", type: :string, default: "*",
                     desc: "List of hosts , seperated. 127.0.0.1,192.168.1.1"
      option :port, aliases: "-p", type: :string, default: "2525", desc: "Smtp port"
      def server
        print_runtime do
          say "Running the SMTP server on #{options[:hosts]}", :magenta
          server = Smtp::Server.new(hosts: options[:hosts], auth_mode: :AUTH_REQUIRED, ports: options[:port])

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
      end
    end
  end
end
