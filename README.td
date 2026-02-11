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

