# Checkme

Have you ever have a problem with bounce rates?
Here there is a SMTP server which also validate all the email addresses before sending the out.

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
azolf/checkme:latest \
/app/bin/checkme server
```

### Statefull
If you want to cache the email addresses in a database you should use this.

You could easily run it with docker-compose.

1. Download the docker-compose file
```
    wget https://raw.githubusercontent.com/azolf/checkme.email/main/docker-compose.yml
```

2. Run the setup
```
docker compose run --rm checkme /app/bin/setup
```

3. Fire up the containers
```
docker compose up -d
```



## Usage

```
docker run --env VERIFIER_EMAIL=test@example.com --env APP_ENV=production --env STATELESS=true azolf/checkme:latest /app/bin/checkme validate -e amirhosein.zlf@gmail.com 
```

## Development

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/azolf/checkme.email

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
