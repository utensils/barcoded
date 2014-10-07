#!/usr/bin/env bash
# This script is the entry point for the Docker container
if /usr/local/docker-scripts/edit-unicorn-config.rb; then
  cd /app/ && bundle exec unicorn -c /app/config/unicorn.rb -E $RACK_ENV
fi
