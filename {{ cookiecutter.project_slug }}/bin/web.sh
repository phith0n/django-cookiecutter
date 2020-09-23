#!/bin/bash

set -eo pipefail

if [ ! -d /data/static ]; then
  mkdir -p /data/static
fi

if [ ! -d /data/media ]; then
  mkdir -p /data/media
fi

mkdir -p data/cache data/logs data/media data/sqlite3 data/static
chown nobody:nobody -R data/

./manage.py collectstatic --no-input
./manage.py migrate --no-input

gunicorn {{ cookiecutter.project_slug }}.wsgi -w 2 -k gevent -u nobody -g nogroup -b 0.0.0.0:8080
