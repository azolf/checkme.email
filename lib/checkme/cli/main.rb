# frozen_string_literal: true

require "thor"
require "dotenv"

module Checkme
  module Cli
    class Main < Base
      desc "validate", "validate an email address"
      option :email, aliases: "-e", type: :string, required: true,
                     desc: "email address to validate"
      option :methods, aliases: "-m", type: :string, default: "regex,mx,smtp,open_mail_domain",
                       desc: "Different methods to check, regex, mx, smtp, open_mail_domain"
      def validate
        invoke "checkme:cli:email:validate", [], options
      end

      desc "server", "Run a smtp server"
      option :hosts, aliases: "-h", type: :string, default: "*",
                     desc: "List of hosts , seperated. 127.0.0.1,192.168.1.1"
      option :port, aliases: "-p", type: :string, default: "2525", desc: "Smtp port"

      option :auth, aliases: '-a', type: :string, default: 'required', desc: "Authentication method, available options: required, optional, forbidden"
      option :methods, aliases: "-m", type: :string, default: "regex,mx,smtp,open_mail_domain",
                       desc: "Different methods to check, regex, mx, smtp, open_mail_domain"
      def server
        invoke "checkme:cli:smtp:server", [], options
      end
    end
  end
end
