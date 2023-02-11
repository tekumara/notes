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
