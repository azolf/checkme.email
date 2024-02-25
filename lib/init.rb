::Mail.defaults do
  delivery_method :smtp, {
      address: ENV['SERVER_SMTP_HOST'],
      port: ENV['SERVER_SMTP_PORT'],
      password: ENV['SERVER_SMTP_PASSWORD'],
      user_name: ENV['SERVER_SMTP_USER'],
      authentication: 'plain',
      domain: ENV['SERVER_SMTP_DOMAIN'],
      enable_starttls_auto: ENV['SERVER_SMTP_ENABLE_TLS'] == 'true'
    }
end

Truemail.configure do |config|
  # Required parameter. Must be an existing email on behalf of which verification will be performed
  config.verifier_email = ENV['VERIFIER_EMAIL']

  # Optional parameter. Must be an existing domain on behalf of which verification will be performed.
  # By default verifier domain based on verifier email
  config.verifier_domain = ENV['VERIFIER_DOMAIN'] unless ENV['VERIFIER_DOMAIN'].nil?

  # Optional parameter. You can override default regex pattern
  config.email_pattern = ENV['EMAIL_PATTERN'] unless ENV['EMAIL_PATTERN'].nil?

  # Optional parameter. You can override default regex pattern
  config.smtp_error_body_pattern = ENV['SMTP_ERROR_BODY_PATTERN'] unless ENV['SMTP_ERROR_BODY_PATTERN'].nil?

  # Optional parameter. Connection timeout in seconds.
  # It is equal to 2 by default.
  config.connection_timeout = ENV['CONNECTION_TIMEOUT'] unless ENV['CONNECTION_TIMEOUT'].nil?

  # Optional parameter. A SMTP server response timeout in seconds.
  # It is equal to 2 by default.
  config.response_timeout = ENV['RESPONSE_TIMEOUT'] unless ENV['RESPONSE_TIMEOUT'].nil?

  # Optional parameter. Total of connection attempts. It is equal to 2 by default.
  # This parameter uses in mx lookup timeout error and smtp request (for cases when
  # there is one mx server).
  config.connection_attempts = ENV['CONNECTION_ATTEMPTS'] unless ENV['CONNECTION_ATTEMPTS'].nil?

  # Optional parameter. You can predefine which type of validation will be used for domains.
  # Also you can skip validation by domain.
  # Available validation types: :regex, :mx, :mx_blacklist, :smtp
  # This configuration will be used over current or default validation type parameter
  # All of validations for 'somedomain.com' will be processed with regex validation only.
  # And all of validations for 'otherdomain.com' will be processed with mx validation only.
  # It is equal to empty hash by default.
  # config.validation_type_for = { 'somedomain.com' => :regex, 'otherdomain.com' => :mx }

  # Optional parameter. Validation of email which contains whitelisted emails always will
  # return true. Other validations will not processed even if it was defined in validation_type_for
  # It is equal to empty array by default.
  config.whitelisted_emails = ENV['WHITELISTED_EMAILS'].to_s.split('') unless ENV['WHITELISTED_EMAILS'].nil?

  # Optional parameter. Validation of email which contains blacklisted emails always will
  # return false. Other validations will not processed even if it was defined in validation_type_for
  # It is equal to empty array by default.
  config.blacklisted_emails = ENV['BLACKLISTED_EMAILS'].to_s.split('') unless ENV['BLACKLISTED_EMAILS'].nil?

  # Optional parameter. Validation of email which contains whitelisted domain always will
  # return true. Other validations will not processed even if it was defined in validation_type_for
  # It is equal to empty array by default.
  config.whitelisted_domains = ENV['WHITELISTED_DOMAINS'].to_s.split('') unless ENV['WHITELISTED_DOMAINS'].nil?

  # Optional parameter. Validation of email which contains blacklisted domain always will
  # return false. Other validations will not processed even if it was defined in validation_type_for
  # It is equal to empty array by default.
  config.blacklisted_domains = ENV['BLACKLISTED_DOMAINS'].to_s.split('') unless ENV['BLACKLISTED_DOMAINS'].nil?

  # Optional parameter. With this option Truemail will validate email which contains whitelisted
  # domain only, i.e. if domain whitelisted, validation will passed to Regex, MX or SMTP validators.
  # Validation of email which not contains whitelisted domain always will return false.
  # It is equal false by default.
  config.whitelist_validation = ENV['WHITELIST_VALIDATION'] == 'true'

  # Optional parameter. With this option Truemail will filter out unwanted mx servers via
  # predefined list of ip addresses. It can be used as a part of DEA (disposable email
  # address) validations. It is equal to empty array by default.
  config.blacklisted_mx_ip_addresses = ENV['BLACKLISTED_MX_IP_ADDRESSES'].to_s.split('') unless ENV['BLACKLISTED_MX_IP_ADDRESSES'].nil?

  # Optional parameter. This option will provide to use custom DNS gateway when Truemail
  # interacts with DNS. Valid port numbers are in the range 1-65535. If you won't specify
  # nameserver's ports Truemail will use default DNS TCP/UDP port 53. By default Truemail
  # uses DNS gateway from system settings and this option is equal to empty array.
  config.dns = ENV['DNS'].to_s.split('') unless ENV['DNS'].nil?

  # Optional parameter. This option will provide to use not RFC MX lookup flow.
  # It means that MX and Null MX records will be cheked on the DNS validation layer only.
  # By default this option is disabled.
  config.not_rfc_mx_lookup_flow = ENV['NOT_RFC_MX_LOOKUP_FLOW'] == 'true'

  # Optional parameter. SMTP port number. It is equal to 25 by default.
  config.smtp_port = ENV['SMTP_PORT'] unless ENV['SMTP_PORT'].nil?

  # Optional parameter. This option will provide to use smtp fail fast behavior. When
  # smtp_fail_fast = true it means that Truemail ends smtp validation session after first
  # attempt on the first mx server in any fail cases (network connection/timeout error,
  # smtp validation error). This feature helps to reduce total time of SMTP validation
  # session up to 1 second. By default this option is disabled.
  config.smtp_fail_fast = ENV['SMTP_FAIL_FAST'] == 'true'

  # Optional parameter. This option will be parse bodies of SMTP errors. It will be helpful
  # if SMTP server does not return an exact answer that the email does not exist
  # By default this option is disabled, available for SMTP validation only.
  config.smtp_safe_check = ENV['SMTP_SAFE_CHECK'] == 'true'

  # Optional parameter. This option will enable tracking events. You can print tracking
  # events to stdout, write to file or both of these. Logger class by default is Logger
  # from Ruby stdlib. Tracking event by default is :error
  # Available tracking event: :all, :unrecognized_error, :recognized_error, :error
  # config.logger = {
  #   logger_class: MyCustomLogger,
  #   tracking_event: :all,
  #   stdout: true,
  #   log_absolute_path: '/home/app/log/truemail.log'
  # }
end
