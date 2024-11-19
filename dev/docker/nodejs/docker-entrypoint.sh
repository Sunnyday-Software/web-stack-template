#!/usr/bin/dumb-init /usr/bin/bash

# https://github.com/Yelp/dumb-init

set -e

# Prevent core dumps
ulimit -c 0

if [ "$(id -u)" = '0' ]; then
  # then restart script as sunnyday user
	exec gosu sunnyday "$BASH_SOURCE" "$@"
fi

exec "$@"

