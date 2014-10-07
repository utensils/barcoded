# Barcoded
#
# VERSION       1.1.0

FROM ubuntu:14.04.1
MAINTAINER Sean Callan, James Brink

# Make sure the package repository is up to date
RUN apt-get update
RUN apt-get dist-upgrade -y
# Ruby is required to build Ruby 2.1.2
RUN apt-get install -y wget curl ruby
RUN apt-get install -y imagemagick libmagickcore-dev libmagickwand-dev

# Ruby build requirements
RUN apt-get install -y build-essential bison openssl libreadline6 libreadline-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev libffi-dev libffi6

# Download, build, and install Ruby 2.1.2
RUN cd /var/tmp && wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz && tar xfvz ruby-2.1.2.tar.gz && cd ruby-2.1.2 && autoconf && ./configure --prefix=/usr/local/  && make && make install && cd .. &&  rm -rf ruby-2*
RUN apt-get remove -y ruby

# Setup webstack
RUN apt-get install -y nginx
RUN gem install unicorn

# Add custom scripts and config files to manage and start application
RUN mkdir /usr/local/docker-scripts
ADD ./docker-scripts/start-barcoded.sh /usr/local/docker-scripts/
RUN chmod +x /usr/local/docker-scripts/start-barcoded.sh
ADD ./docker-scripts/edit-unicorn-config.rb /usr/local/docker-scripts/
RUN chmod +x /usr/local/docker-scripts/edit-unicorn-config.rb

# Add project files 
RUN mkdir /app
ADD ./Gemfile /app/
ADD ./Gemfile.lock /app/
ADD ./Rakefile /app/
ADD ./barcoded.rb /app/
ADD ./config.ru /app/
ADD ./config /app/config
ADD ./lib /app/lib
ADD ./spec /app/spec
ADD ./docker-scripts/unicorn.rb /app/config/

# Setup needed directories for unicorn
RUN mkdir /app/tmp
RUN mkdir /app/tmp/sockets
RUN mkdir /app/tmp/pids
RUN mkdir /app/log

# Install needed gems
RUN gem install bundler
RUN cd /app/ && bundle install

# Set ENV Variables
ENV RACK_ENV production
ENV RACK_CORS disabled
ENV UNICORN_WORKERS 1
ENV UNICORN_TIMEOUT 30
ENV UNICORN_BACKLOG 64

EXPOSE 8080
CMD ["/usr/local/docker-scripts/start-barcoded.sh"]
