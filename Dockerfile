FROM docker:26-cli

# Install required tools (cron lives in busybox, but we use dcron for proper behavior)
RUN apk add --no-cache \
    bash \
    tzdata \
    dcron

WORKDIR /app

COPY compose-auto-update.sh /app/compose-auto-update.sh
RUN chmod +x /app/compose-auto-update.sh

# Cron job → log to container stdout
RUN echo "*/1 * * * * /app/compose-auto-update.sh >> /proc/1/fd/1 2>&1" | crontab -

# Signal-handling entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
