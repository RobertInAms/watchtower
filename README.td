# Watchtower replacement

After happily using containrrr/watchtower:latest for many years, it is no longer
compatilbe with the current docer versions. Unfortunatly the project is no
longer maintained so we had to look for a different solution. This proved to 
be very complex so we implemented a poormans implentation

Watchtower is very advanded and it retieves all settings from the running container
This project solves this by mounting the docker-compose in the container and
use those settings

# Github

https://github.com/RobertInAms/watchtower

# Docker file sample

```

  nginx:
    image: robertinams/connection:devhttp
    container_name: nginx
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
