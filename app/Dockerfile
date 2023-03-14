FROM ruby:3.2.1

RUN apt-get update -qq
RUN apt-get upgrade -y --force-yes

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

COPY . .