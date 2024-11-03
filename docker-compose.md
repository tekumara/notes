# docker compose

Remove stopped containers

```
docker compose rm
```

Remove stopped containers and networks and volumes

```
docker compose down -v
```

Remove orphaned services

```
docker compose down --remove-orphans
```

Run service with bash

```
docker compose run app /bin/bash
```

To run service and expose its ports to the host:

```
docker compose run --service-ports app
```

## macos

Docker Desktop ships:

- docker-compose v2
- docker compose v2

## Troubleshooting

### Error response from daemon: network ... not found

A service is dependent on another service in a different profile, eg:

```
    profiles: ["frontend"]
    depends_on:
      backend:
        condition: service_started
```

But the qdrant service is not in the `app` profile.

Either align the profiles or place them all on the same network, eg:

```
networks:
  common_network:
    driver: bridge

services:
  web:
    image: nginx
    profiles: ["frontend"]
    networks:
      - common_network
    depends_on:
      backend:
        condition: service_started

  api:
    image: my-api
    profiles: ["backend"]
    networks:
      - common_network

  db:
    image: postgres
    profiles: ["backend"]
    networks:
      - common_network
```
