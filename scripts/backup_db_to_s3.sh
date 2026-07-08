#!/usr/bin/env bash
# Dumps a MySQL database and uploads the backup to an S3 bucket.
# Usage: ./backup_db_to_s3.sh <db_name> <s3_bucket> [db_host] [db_user] [db_pass]
# Credentials: relies on AWS CLI's normal credential chain (env vars, ~/.aws/credentials,
# or Jenkins "Secret text"/"Username & password" bindings injected as env vars).
set -euo pipefail

DB_NAME="${1:?db_name is required}"
S3_BUCKET="${2:?s3_bucket is required}"
DB_HOST="${3:-mysql-db}"
DB_USER="${4:-labuser}"
DB_PASS="${5:-labpass}"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="${DB_NAME}_${TIMESTAMP}.sql.gz"
BACKUP_DIR="${BACKUP_DIR:-/tmp/backups}"
mkdir -p "$BACKUP_DIR"

echo "Dumping ${DB_NAME} from ${DB_HOST}..."
mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" | gzip > "${BACKUP_DIR}/${BACKUP_FILE}"

echo "Uploading ${BACKUP_FILE} to s3://${S3_BUCKET}/..."
aws s3 cp "${BACKUP_DIR}/${BACKUP_FILE}" "s3://${S3_BUCKET}/${BACKUP_FILE}"

echo "Backup complete: s3://${S3_BUCKET}/${BACKUP_FILE}"
