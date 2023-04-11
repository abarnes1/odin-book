#!/bin/sh
set -e

rm -f tmp/pids/server.pid

bin/rails db:create
bin/rails db:migrate
RAILS_ENV=production bin/rails assets:precompile
exec "$@"