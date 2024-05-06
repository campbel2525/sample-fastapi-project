#!/bin/bash
set -e

echo "$APP_ENV_VALUES" > .env

# サーバー起動
# 本当はgunicornで実行したい
pipenv run uvicorn main:app --host 0.0.0.0 --reload --port 8000
