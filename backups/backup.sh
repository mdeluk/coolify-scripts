#!/bin/bash
# PostgreSQL backup script for Coolify services
# All sensitive values are loaded from environment variables

echo "Starting backup process at $(date)"

# Create backup directory
mkdir -p /backups/postgres

# Validate required environment variables
if [ -z "$DOCUSEAL_CONTAINER" ] || [ -z "$N8N_CONTAINER" ]; then
    echo "ERROR: Required container environment variables not set"
    echo "Required: DOCUSEAL_CONTAINER, N8N_CONTAINER"
    exit 1
fi

if [ -z "$DOCUSEAL_USER" ] || [ -z "$N8N_USER" ]; then
    echo "ERROR: Required user environment variables not set"
    echo "Required: DOCUSEAL_USER, N8N_USER"
    exit 1
fi

if [ -z "$DOCUSEAL_DB" ] || [ -z "$N8N_DB" ]; then
    echo "ERROR: Required database environment variables not set"
    echo "Required: DOCUSEAL_DB, N8N_DB"
    exit 1
fi

# Backup n8n database
echo "Backing up n8n database..."
if docker exec $N8N_CONTAINER pg_dump -U $N8N_USER $N8N_DB > /backups/postgres/n8n_$(date +%Y%m%d_%H%M%S).sql; then
    echo "n8n backup completed successfully"
else
    echo "ERROR: n8n backup failed"
fi

# Backup docuseal database
echo "Backing up docuseal database..."
if docker exec $DOCUSEAL_CONTAINER pg_dump -U $DOCUSEAL_USER $DOCUSEAL_DB > /backups/postgres/docuseal_$(date +%Y%m%d_%H%M%S).sql; then
    echo "docuseal backup completed successfully"
else
    echo "ERROR: docuseal backup failed"
fi

# Keep only last 7 backups for each service
echo "Cleaning up old backups..."
find /backups/postgres -name "n8n_*.sql" -type f -mtime +7 -delete
find /backups/postgres -name "docuseal_*.sql" -type f -mtime +7 -delete

echo "Backup process completed at $(date)"