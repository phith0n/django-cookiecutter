#!/bin/bash

set -eo pipefail

./manage.py collectstatic --no-input
./manage.py migrate --no-input

dirs=('cache' 'logs' 'media' 'sqlite3' 'statiic')
for dir in "${dirs[@]}"; do
  mkdir -p "data/${dir}"
  chown -R nobody:nogroup "data/${dir}"
done

gunicorn -w 2 -k gevent -u nobody -g nogroup -b 0.0.0.0:8080 {{ cookiecutter.project_slug }}.wsgi
