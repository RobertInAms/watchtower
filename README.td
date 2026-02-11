# Watchtower Replacement

After happily using `containrrr/watchtower:latest` for many years, it became incompatible with current Docker versions. Unfortunately, the project is no longer maintained, so we had to find an alternative.

Existing replacements turned out to be complex, so we implemented a **simpler, practical solution** — a “poor man’s Watchtower”.

---

## How This Differs From Watchtower

**Watchtower** is very advanced. It reads all configuration directly from the running container and recreates containers using the Docker API.

This project takes a different approach:

- The `docker-compose.yml` file is mounted into the container  
- The updater uses `docker compose` internally  
- Containers are recreated using the original Compose configuration  

This ensures:

- Environment variables are preserved  
- Volumes and networks stay intact  
- Only updated services are recreated  
- No need to reverse-engineer container runtime config  

---

## GitHub Repository

👉 https://github.com/RobertInAms/watchtower

---

## Internals

The project’s `docker-compose.yml` is mounted inside the container at:

```
/app/docker-compose.yml
```

The updater then runs `docker compose` commands against this file to recreate services when a new image version is detected.

---

## Sample docker-compose.yml

```yaml
services:
  nginx:
    image: robertinams/connection:devhttp
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - printserver

  watchtower:
    image: robertinams/watchtower:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./docker-compose.yml:/app/docker-compose.yml
```

---

## Summary

This project provides a lightweight, Compose-native alternative to Watchtower:

- No heavy monitoring daemon  
- No registry API flooding  
- No complex configuration  
- Fully preserves Compose-based setups  

It focuses on **reliability and simplicity** over feature richness.
