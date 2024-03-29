# Checkme


## Overview
checkme is an open-source project designed to simplify the setup of an SMTP server with built-in email address validation. Leveraging the powerful [trueMail](https://github.com/truemail-rb/truemail) library, checkme ensures that email addresses are validated before being sent, enhancing the reliability and deliverability of your emails.
This image show how the SMTP server works.
![](./imgs/Checkme.jpg)


## Features
- Email Address Validation: checkme integrates seamlessly with the trueMail library, allowing for robust email address validation to ensure the accuracy of recipient addresses.

- Customizable Validations: Tailor the validation process to your specific requirements by customizing the types of validations performed on email addresses.

- Stateful Mode: Enhance performance and reduce redundancy with the option to run checkme in a stateful mode. This mode caches all validations in a PostgreSQL database, preventing multiple checks for regularly used email addresses.



## Installation

### Stateless
With stateless version it doesn't cache the records in the database and everytime check all the validations.
You just need to pass env `STATELESS=true` when running the checkme.email.

```
docker run --env VERIFIER_EMAIL=test@example.com \
--env APP_ENV=production \
--env STATELESS=true \
--env AUTH_USERNAME=USERNAME \
--env AUTH_PASSWORD=PASSWORD \
--publish 2525:2525 \
ghcr.io/azolf/checkme:latest \
/app/bin/checkme server
```

### Statefull
If you want to cache the email addresses in a database you should use this.

You could easily run it with docker-compose.

1. Download the docker-compose file
```
    wget https://raw.githubusercontent.com/azolf/checkme.email/main/examples/docker-compose.yml
```

2. Run the setup
```
docker compose run --rm checkme /app/bin/setup
```

3. Fire up the containers
```
docker compose up -d
```



## Simple Usage To Check email

```
docker run --env VERIFIER_EMAIL=test@example.com --env APP_ENV=production --env STATELESS=true ghcr.io/azolf/checkme:latest /app/bin/checkme validate -e amirhosein.zlf@gmail.com 
```


## Utilization
Since we are using [MidiSmtpServer](https://midi-smtp-server.readthedocs.io) to manage SMTP connection you could read the whole utilization details under [Load Balancing feature](https://midi-smtp-server.readthedocs.io/feature_load_balancing/).


# Environment Variables

## Environment Variables For Application Mode
| Name        | Description                                                                                                                                             | Required              | Default Value |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- | ------------- |
| STATELESS   | When set to true it doesn't need any database configuration and it doesn't cache the email addresses. When set to true the below credentials are needed | No                    | FALSE         |
| DB_NAME     | Database name                                                                                                                                           | Yes if STATELESS=true |               |
| DB_POOL     | Database number of pool connection                                                                                                                      | Yes if STATELESS=true |               |
| DB_USER     | Database username                                                                                                                                       | Yes if STATELESS=true |               |
| DB_PASSWORD | Database password                                                                                                                                       | Yes if STATELESS=true |


## Environment Variables For TrueMail
| Name                        | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Required | Default Value                                                                                                                                                            |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| VERIFIER_EMAIL              | Must be an existing email on behalf of which verification will be performed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Yes      |                                                                                                                                                                          |
| VERIFIER_DOMAIN             | Must be an existing domain on behalf of which verification will be performed.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | No       | verifier domain based on verifier email                                                                                                                                  |
| EMAIL_PATTERN               | You can override default regex pattern                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | No       | /(?=\\A.{6,255}\\z)(\\A([\\p{L}0-9]+[\\w\\p{L}.+!~,'&%#\*^\`{}|\\-\\/?=$]\*)@((?i-mx:[\\p{L}0-9]+([-.]{1}[\\p{L}\\p{N}\\p{Pd}]\*[\\p{L}\\p{N}]+)\*\\.\\p{L}{2,63}))\\z)/ |
| SMTP_ERROR_BODY_PATTERN     | You can override default regex pattern                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | No       | /(?=.\*550)(?=.\*(user|account|customer|mailbox)).\*/i                                                                                                                   |
| CONNECTION_TIMEOUT          | Connection timeout in seconds.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | No       | 2                                                                                                                                                                        |
| RESPONSE_TIMEOUT            | A SMTP server response timeout in seconds.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | No       | 2                                                                                                                                                                        |
| CONNECTION_ATTEMPTS         | Total of connection attempts.<br>This parameter uses in mx lookup timeout error and smtp request (for cases when there is one mx server).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | No       | 2                                                                                                                                                                        |
| WHITELISTED_EMAILS          | You can predefine which type of validation will be used for domains.<br>Also you can skip validation by domain.<br>Available validation types: :regex, :mx, :mx_blacklist, :smtp<br>This configuration will be used over current or default validation type parameter<br>All of validations for 'somedomain.com' will be processed with regex validation only.<br>And all of validations for 'otherdomain.com' will be processed with mx validation only.<br>It is equal to empty hash by default.<br>config.validation_type_for = { 'somedomain.com' => :regex, 'otherdomain.com' => :mx }<br><br>Optional parameter. Validation of email which contains whitelisted emails always will<br>return true. Other validations will not processed even if it was defined in validation_type_for | No       |                                                                                                                                                                          |
| BLACKLISTED_EMAILS          | Validation of email which contains blacklisted emails always will return false. Other validations will not processed even if it was defined in validation_type_for                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | No       | It is equal to empty array by default.                                                                                                                                   |
| WHITELISTED_DOMAINS         | Validation of email which contains whitelisted domain always will return true. Other validations will not processed even if it was defined in validation_type_for                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | No       | It is equal to empty array by default.                                                                                                                                   |
| BLACKLISTED_DOMAINS         | Validation of email which contains blacklisted domain always will return false. Other validations will not processed even if it was defined in validation_type_for                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | No       | It is equal to empty array by default.                                                                                                                                   |
| WHITELIST_VALIDATION        | With this option Truemail will validate email which contains whitelisted domain only, i.e. if domain whitelisted, validation will passed to Regex, MX or SMTP validators.<br>Validation of email which not contains whitelisted domain always will return false.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | No       | FALSE                                                                                                                                                                    |
| BLACKLISTED_MX_IP_ADDRESSES | With this option Truemail will filter out unwanted mx servers via predefined list of ip addresses. It can be used as a part of DEA (disposable email address) validations.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | No       | It is equal to empty array by default.                                                                                                                                   |
| DNS                         | This option will provide to use custom DNS gateway when Truemail<br>interacts with DNS. Valid port numbers are in the range 1-65535. If you won't specify<br>nameserver's ports Truemail will use default DNS TCP/UDP port 53. By default Truemail<br>uses DNS gateway from system settings and this option is equal to empty array.<br>                                                                                                                                                                                                                                                                                                                                                                                                                                                    |          |                                                                                                                                                                          |
| NOT_RFC_MX_LOOKUP_FLOW      | This option will provide to use not RFC MX lookup flow.<br>It means that MX and Null MX records will be cheked on the DNS validation layer only.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | No       | By default this option is disabled.                                                                                                                                      |
| SMTP_PORT                   | SMTP port number.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | No       | 25                                                                                                                                                                       |
| SMTP_FAIL_FAST              | This option will provide to use smtp fail fast behavior. When smtp_fail_fast = true it means that Truemail ends smtp validation session after first attempt on the first mx server in any fail cases (network connection/timeout error, smtp validation error). This feature helps to reduce total time of SMTP validation session up to 1 second.                                                                                                                                                                                                                                                                                                                                                                                                                                          | No       | By default this option is disabled.                                                                                                                                      |
| SMTP_SAFE_CHECK             | This option will be parse bodies of SMTP errors. It will be helpful if SMTP server does not return an exact answer that the email does not exist<br>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | No       | By default this option is disabled, available for SMTP validation only.                                                                                                  |



## Environment Variables For Outgoing SMTP Server
Set these variables so the incoming mails will send with these configurations.

| Name                   | Description                     | Required | Default Value |
| ---------------------- | ------------------------------- | -------- | ------------- |
| SERVER_SMTP_HOST       | Host address of the smtp server | Yes      |               |
| SERVER_SMTP_PORT       | Port number of smtp server      | Yes      |               |
| SERVER_SMTP_PASSWORD   | Password of smtp server         | Yes      |               |
| SERVER_SMTP_USER       | Username of smtp server         | Yes      |               |
| SERVER_SMTP_DOMAIN     | Domain for smtp mail server     | Yes      |               |
| SERVER_SMTP_ENABLE_TLS | Set true to use TLS             | No       | FALSE         |


## Environemt Variable For Incoming SMTP Server
Set these variables to setup the SMTP server and accept incoming mails.
| Name          | Description              | Required |
| ------------- | ------------------------ | -------- |
| AUTH_USERNAME | Username for smtp server | Yes      |
| AUTH_PASSWORD | Password for smtp server | Yes      |


## Development

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/azolf/checkme.email

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
