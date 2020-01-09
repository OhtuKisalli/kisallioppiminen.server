FROM ruby:2.4.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /kisalliserver
WORKDIR /kisalliserver
ADD Gemfile /kisalliserver/Gemfile
ADD Gemfile.lock /kisalliserver/Gemfile.lock
RUN bundle install
ADD . /kisalliserver
RUN rm -f tmp/pids/server.pid

CMD "/kisalliserver/entrypoint.sh"
