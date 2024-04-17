#!/bin/bash
set -e

echo "$APP_ENV_VALUES" > .env

exec "$@"
