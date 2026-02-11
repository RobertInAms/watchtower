#!/usr/bin/env bash
set -euo pipefail

cd /app

# Get the project name of THIS container
SELF_ID=$(hostname)
PROJECT=$(docker inspect --format '{{ index .Config.Labels "com.docker.compose.project" }}' "$SELF_ID")
echo "[$(date)] Checking updates for project: $PROJECT"
echo "[$(date)] Checking updates for project: $PROJECT" >> /tmp/log.txt

for cid in $(docker ps -q --filter "label=com.docker.compose.project=$PROJECT"); do
  service=$(docker inspect --format '{{ index .Config.Labels "com.docker.compose.service" }}' "$cid")
  image=$(docker inspect --format '{{.Config.Image}}' "$cid")

  name="$PROJECT/$service"

  old_image_id=$(docker inspect --format '{{.Image}}' "$cid")

  docker pull "$image" > /dev/null 2>&1 || continue

  new_image_id=$(docker image inspect "$image" --format '{{.Id}}')

  if [[ "$old_image_id" != "$new_image_id" ]]; then
    echo "⬆ Update found for $name → recreating"
    docker compose -p "$PROJECT" up -d --no-deps --force-recreate "$service"
  else
    echo "✓ $name up to date"
  fi
done
