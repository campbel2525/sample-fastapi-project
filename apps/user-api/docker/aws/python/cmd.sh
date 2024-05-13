#!/bin/bash
set -e

echo "$APP_ENV_VALUES" > .env

# サーバー起動
# 本当はgunicornで実行したい
# pipenv run uvicorn main:app --host 0.0.0.0 --port 8000
pipenv run gunicorn --workers 4 --worker-class uvicorn.workers.UvicornWorker main:app --bind 0.0.0.0:8000 --timeout 120
