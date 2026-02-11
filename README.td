# Watchtower replacement

After happily using containrrr/watchtower:latest for many years, it is no longer
compatilbe with the current docker versions. Unfortunatly the project is no
longer maintained so we had to look for a different solution. This proved to 
be very complex so we implemented a poormans implentation

Watchtower is very advanded and it retrieves all settings from the running container
This project solves this by mounting the docker-compose.yml in the container and
use those settings by using "docker compose" insite the watchtower container

# Github

https://github.com/RobertInAms/watchtower

# Internals

The docker-compose.yml is mounted in /app

# docker-compose.yml Sample

```

  nginx:
    image: robertinams/connection:devhttp
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - printserver
    # command: ["tail", "-f", "/dev/null"]

  watchtower:
    image: robertinams/watchtower:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./docker-compose.yml:/app/docker-compose.yml
```
