#!/bin/sh
set -e

rm -f tmp/pids/server.pid

RAILS_ENV=production bin/rails assets:precompile
exec "$@"