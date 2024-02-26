FROM ruby:3.2.3
# RUN apk add --update git

WORKDIR /app
COPY . /app/

RUN bundle install

CMD ["/app/bin/checkme",  "server"]