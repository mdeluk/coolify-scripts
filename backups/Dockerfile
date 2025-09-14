FROM alpine:latest

# Install required packages
RUN apk add --no-cache \
    postgresql-client \
    dcron \
    docker-cli \
    bash

# Create directories
RUN mkdir -p /scripts /backups/postgres

# Copy backup script
COPY backup.sh /scripts/
RUN chmod +x /scripts/backup.sh

# Set up cron job (runs daily at 2 AM)
RUN echo "0 2 * * * /scripts/backup.sh >> /var/log/backup.log 2>&1" | crontab -

# Start cron daemon
CMD ["crond", "-f", "-d", "8"]