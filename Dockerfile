FROM ruby:3.2.2-alpine

# LABEL maintainer="myemail@domain.com"

# update package list
# add libxslt-dev libxml2-dev if needed for nokogiri
RUN apk --update add build-base tzdata postgresql-dev postgresql-client tree
  
# Copy gems first so layer with bundle install can be
# cached and not rebuilt when changing other code
COPY Gemfile* /usr/src/app/

# effectively a cd /usr/src/app
WORKDIR /usr/src/app

# Used to set known location for gems to use in gem cache
ENV BUNDLE_PATH /gems

RUN bundle install

# copy rails app to /usr/src/app/ the in the container
COPY . /usr/src/app/

# executes docker-entrypoint.sh script that
# deletes server.pid in case of unclean shutdown
ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
