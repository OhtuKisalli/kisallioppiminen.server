#!/usr/bin/env bash
set -euo pipefail
set -x

bundle exec rake db:migrate
exec bundle exec rails s -e production -p $PORT -b '0.0.0.0'
