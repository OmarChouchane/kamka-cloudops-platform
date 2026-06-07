#!/usr/bin/env bash
set -euo pipefail

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="kamka_db_${TIMESTAMP}.sql.gz"
S3_BUCKET="${S3_BACKUP_BUCKET:?S3_BACKUP_BUCKET not set}"

echo "[backup] Dumping database..."
docker exec kamka-postgres pg_dumpall -U kamka_user | gzip > "/tmp/${BACKUP_FILE}"

echo "[backup] Uploading to S3..."
aws s3 cp "/tmp/${BACKUP_FILE}" "s3://${S3_BUCKET}/backups/${BACKUP_FILE}" \
  --sse aws:kms

echo "[backup] Cleaning local copy..."
rm "/tmp/${BACKUP_FILE}"

echo "[backup] Done: s3://${S3_BUCKET}/backups/${BACKUP_FILE}"
