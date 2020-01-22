#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f ${PWD}/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

# # Default command
bundle install
rails s -p ${APP_PORT} -b ${APP_SERVER_HOST}

