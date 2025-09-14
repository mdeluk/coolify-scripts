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

# Create cron job file
RUN echo "0 2 * * * /scripts/backup.sh >> /var/log/backup.log 2>&1" > /etc/crontabs/root

# Create startup script to handle cron properly
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'echo "Starting backup service..."' >> /start.sh && \
    echo 'crond -f -d 8' >> /start.sh && \
    chmod +x /start.sh

# Start cron daemon with proper flags
CMD ["/start.sh"]
