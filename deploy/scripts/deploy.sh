#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG="${1:-latest}"

cd /opt/kamka

echo "[deploy] Pulling images (tag: $IMAGE_TAG)..."
IMAGE_TAG="$IMAGE_TAG" docker compose pull

echo "[deploy] Recreating services..."
docker compose up -d --remove-orphans --force-recreate

echo "[deploy] Running migrations..."
bash "$(dirname "$0")/migrate.sh"

echo "[deploy] Health check..."
sleep 10
curl -f http://localhost/healthz || { echo "Health check failed"; exit 1; }

echo "[deploy] Done."
