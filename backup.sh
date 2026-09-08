#!/usr/bin/env bash
set -e

BACKUP_DIR="./backups"
mkdir -p $BACKUP_DIR
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/postgres_backup_$TIMESTAMP.sql"

echo "Creating PostgreSQL backup..."
docker exec postgres pg_dump -U barq_app barq_tasks > "$BACKUP_FILE"
echo "Backup created successfully at: $BACKUP_FILE ✅"
