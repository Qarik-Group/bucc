FROM alpine
RUN apk add --no-cache ruby bash curl

# json gem uses
RUN apk add --no-cache ruby-dev build-base
RUN gem install json --no-doc
RUN apk del ruby-dev build-base
