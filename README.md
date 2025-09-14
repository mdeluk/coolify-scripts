# Database Backup Service

Automated backup solution for PostgreSQL databases running in Coolify.

## Current Services
- n8n database
- DocuSeal database

## Deployment
1. Update container names in `backup.sh`
2. Deploy this directory as a service in Coolify
3. Monitor logs to verify operation

## Adding New Databases
Edit `backup.sh` and add new backup commands following the existing pattern.
