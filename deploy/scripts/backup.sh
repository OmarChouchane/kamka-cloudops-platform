#!/usr/bin/env bash
set -euo pipefail

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="kamka_db_${TIMESTAMP}.sql.gz"
S3_BUCKET="${S3_BACKUP_BUCKET:?S3_BACKUP_BUCKET not set}"
TEXTFILE_DIR="/var/lib/node-exporter/textfile"

echo "[backup] Dumping database..."
docker exec kamka-postgres pg_dumpall -U kamka_user | gzip > "/tmp/${BACKUP_FILE}"

echo "[backup] Uploading to S3..."
aws s3 cp "/tmp/${BACKUP_FILE}" "s3://${S3_BUCKET}/backups/${BACKUP_FILE}" \
  --sse aws:kms

echo "[backup] Cleaning local copy..."
rm "/tmp/${BACKUP_FILE}"

echo "[backup] Recording success metric..."
mkdir -p "$TEXTFILE_DIR"
printf '# HELP backup_last_success_timestamp Unix timestamp of last successful backup\n# TYPE backup_last_success_timestamp gauge\nbackup_last_success_timestamp %s\n' \
  "$(date +%s)" > "${TEXTFILE_DIR}/backup.prom.$$"
mv "${TEXTFILE_DIR}/backup.prom.$$" "${TEXTFILE_DIR}/backup.prom"

echo "[backup] Done: s3://${S3_BUCKET}/backups/${BACKUP_FILE}"
