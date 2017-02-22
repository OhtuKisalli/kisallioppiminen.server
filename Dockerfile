FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /dockerbeerapp
WORKDIR /dockerbeerapp
ADD Gemfile /dockerbeerapp/Gemfile
ADD Gemfile.lock /dockerbeerapp/Gemfile.lock
RUN bundle install
ADD . /dockerbeerapp
RUN rm -f tmp/pids/server.pid