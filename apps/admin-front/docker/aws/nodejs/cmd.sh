#!/bin/sh
set -e

echo "$APP_ENV_VALUES" > .env

npm start
