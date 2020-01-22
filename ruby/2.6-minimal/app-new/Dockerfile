#Docker image to a new project
FROM ruby:2.6.4-slim-stretch

LABEL author="R3M"

ENV LANG C.UTF-8

#Install dependencies of System for my App
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev gnupg2\
    nano git mysql-client default-libmysqlclient-dev curl --no-install-recommends

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
    
RUN apt-get update && apt-get install -y yarn 

ENV APP_ROOT /myrailsapp
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN gem install bundler && gem install rake && gem install rails 
RUN bundle install -j $(nproc) && bundle update -j $(nproc)
RUN apt-get install nodejs