#!/usr/bin/env bash
# This script is the entry point for the Docker container
if /home/barcoded/edit-unicorn-config.rb; then
  cd /app/ && unicorn -c /home/barcoded/unicorn.rb -E $RACK_ENV
fi
