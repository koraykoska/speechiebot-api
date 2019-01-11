# base image
FROM ruby:2.3.8-slim-jessie

# system dependencies
RUN apt-get -y update
RUN apt-get -y install flac sox libsox-fmt-base opus-tools
RUN apt-get -y install curl

# build only Dependencies
RUN apt-get -y install build-essential

# set working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# add app
COPY . /usr/src/app

# install ruby dependencies
RUN bundle

# remove build only dependencies
RUN apt-get -y remove build-essential
RUN apt-get -y autoremove

# run server
CMD ["bundle", "exec", "puma", "config.ru", "--port", "80"]
