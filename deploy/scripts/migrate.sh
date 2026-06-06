#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.prod.yml}"

echo "[migrate] Running database migrations..."
docker compose -f "$COMPOSE_FILE" run --rm api \
  sh -c "npm run sequelize db:migrate"

echo "[migrate] Done."
