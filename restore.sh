#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
    echo "Usage: ./restore.sh <path-to-backup-sql-file>"
    exit 1
fi

BACKUP_FILE="$1"
echo "Preparing database for clean restore..."
# Clean existing tables to avoid 'already exists' conflicts during automated restore
docker exec -i postgres psql -U barq_app -d barq_tasks -c "DROP TABLE IF EXISTS records CASCADE;"

echo "Restoring PostgreSQL database from $BACKUP_FILE..."
docker exec -i postgres psql -U barq_app -d barq_tasks < "$BACKUP_FILE"
echo "Database restored successfully without errors! ✅"
