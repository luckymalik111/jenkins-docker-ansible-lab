#!/usr/bin/env bash
# Inserts N random users into the "users" table.
# Usage: ./feed_db.sh <count> <db_host> <db_name> <db_user> <db_pass>
set -euo pipefail

COUNT="${1:-10}"
DB_HOST="${2:-mysql-db}"
DB_NAME="${3:-usersdb}"
DB_USER="${4:-labuser}"
DB_PASS="${5:-labpass}"

FIRST_NAMES=(Alice Bob Carol Dave Erin Frank Grace Heidi Ivan Judy)
LAST_NAMES=(Smith Johnson Williams Brown Jones Garcia Miller Davis Lopez Wilson)

for i in $(seq 1 "$COUNT"); do
    FIRST="${FIRST_NAMES[$RANDOM % ${#FIRST_NAMES[@]}]}"
    LAST="${LAST_NAMES[$RANDOM % ${#LAST_NAMES[@]}]}"
    NAME="${FIRST} ${LAST}"
    EMAIL="$(echo "${FIRST}.${LAST}${i}" | tr '[:upper:]' '[:lower:]')@example.com"

    mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" \
        -e "INSERT INTO users (name, email) VALUES ('${NAME}', '${EMAIL}');"
done

echo "Inserted ${COUNT} users into ${DB_NAME}.users on ${DB_HOST}"
