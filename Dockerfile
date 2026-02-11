FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    cron \
    bash \
    gnupg \
    lsb-release \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Add Docker official repo
RUN install -m 0755 -d /etc/apt/keyrings \
 && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
 && chmod a+r /etc/apt/keyrings/docker.gpg \
 && echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list

# Install Docker CLI + Compose plugin
RUN apt-get update && apt-get install -y \
    docker-ce-cli \
    docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY compose-auto-update.sh /app/compose-auto-update.sh
RUN chmod +x /app/compose-auto-update.sh

# Cron job every 10 minutes
RUN echo "*/1 * * * * root /app/compose-auto-update.sh >> /var/log/update.log 2>&1" > /etc/cron.d/updater \
 && chmod 0644 /etc/cron.d/updater \
 && crontab /etc/cron.d/updater

CMD ["cron", "-f"]

