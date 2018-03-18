#!/usr/bin/env sh
# This script is the entry point for the Docker container
echo "=======Environment Variables======="
echo "RACK_ENV=$RACK_ENV"
echo "RACK_CORS=$RACK_CORS"
echo "UNICORN_WORKERS=$UNICORN_WORKERS"
echo "UNICORN_TIMEOUT=$UNICORN_TIMEOUT"
echo "UNICORN_BACKLOG=$UNICORN_BACKLOG"
# Run the config script.
ruby /usr/local/bin/edit-unicorn-config.rb
echo "=======Starting Barcoded======="
# Start unicorn in the background.
bundle exec unicorn -c /usr/local/etc/barcoded/unicorn.rb -E $RACK_ENV &
pid="$!"
trap "echo 'Stopping Barcoded - pid: $pid'; kill -SIGTERM $pid" SIGINT SIGTERM
# Wait for process to end.
while kill -0 $pid > /dev/null 2>&1; do
    wait
done
echo "Exiting"
