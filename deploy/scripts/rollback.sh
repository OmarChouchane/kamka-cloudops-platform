#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG="${1:?Usage: rollback.sh <previous-tag>}"

cd /opt/kamka

echo "[rollback] Switching to tag: $IMAGE_TAG..."
IMAGE_TAG="$IMAGE_TAG" docker compose up -d --remove-orphans --force-recreate

echo "[rollback] Health check..."
sleep 10
curl -f http://localhost/healthz || { echo "Health check failed after rollback"; exit 1; }

echo "[rollback] Done. Running on tag: $IMAGE_TAG"
