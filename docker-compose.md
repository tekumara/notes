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

## macos

Docker Desktop ships:

- docker-compose v1
- docker compose v2

## ubuntu

docker-compose v2 can be installed from [docker/compose](https://github.com/docker/compose).

To integrate it into the docker cli as `docker compose`:

```
sudo ln -s "$(which docker-compose)" /usr/libexec/docker/cli-plugins/docker-compose
```
