#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
	set -- grs_oneshot "$@"
fi

# Allow the container to be started with `--user`, if running as root drop privileges
if [ "$1" = 'grs_oneshot' -a "$(id -u)" = '0' ]; then
	chown -R groestlcoin .
	exec gosu groestlcoin "$0" "$@"
fi

# If not root (i.e. docker run --user $USER ...), then run as invoked
exec "$@"
