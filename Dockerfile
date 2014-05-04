# Barcoded
#
# VERSION       1.0

FROM ubuntu:12.04
MAINTAINER Sean Callan, James Brink

# Make sure the package repository is up to date
RUN apt-get update

# Ruby is required to build Ruby 2.1.1
RUN apt-get install -y wget curl ruby
RUN apt-get install -y imagemagick libmagickcore-dev libmagickwand-dev

# Ruby build requirements
RUN apt-get install -y build-essential bison openssl libreadline6 libreadline-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev libffi-dev libffi6

# Download, build, and install Ruby 2.1.1
RUN cd /var/tmp && wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.1.tar.gz && tar xfvz ruby-2.1.1.tar.gz && cd ruby-2.1.1 && autoconf && ./configure --prefix=/usr/local/  && make && make install && cd .. &&  rm -rf ruby-2*
RUN apt-get remove -y ruby

# Setup barcoded user to run the application
RUN groupadd barcoded
RUN useradd -g barcoded -G users -d /home/barcoded -m -s /bin/bash barcoded
RUN mkdir /app
RUN chown barcoded:barcoded /app

# Allow barcoded user to install gems
RUN chown -R root:barcoded /usr/local/lib/ruby
RUN chmod -R 775 /usr/local/lib/ruby
RUN chown -R root:barcoded /usr/local/bin 
RUN chmod -R 775 /usr/local/bin

# Add project files including git repo for development purposes
USER barcoded
ADD ./Gemfile /app/
ADD ./Gemfile.lock /app/
ADD ./Rakefile /app/
ADD ./barcoded.rb /app/
ADD ./config.ru /app/
ADD ./config /app/config
ADD ./lib /app/lib
ADD ./spec /app/spec

# Install needed gems
RUN gem install bundler
RUN cd /app/ && bundle install

# Set ENV Variables
ENV RACK_ENV production

EXPOSE 9292
CMD cd /app/ && bundle exec rackup -o 0.0.0.0
