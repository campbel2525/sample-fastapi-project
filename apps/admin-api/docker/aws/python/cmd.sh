#!/bin/bash
set -e

echo "$APP_ENV_VALUES" > .env

# サーバー起動
# 本当はgunicornで実行したい
pipenv run uvicorn main:app --host 0.0.0.0 --port 8000
