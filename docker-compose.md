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

## SSH agent forwarding

```yaml
# enable ssh agent forwarding for cloning from github
volumes:
  - type: bind
    source: /run/host-services/ssh-auth.sock
    target: /run/host-services/ssh-auth.sock
environment:
  - SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock
```

## Troubleshooting

### Error response from daemon: network ... not found

This can happen when a container is created with a network and `docker compose down` removes the network but not the container. This will happen when the container is part of a profile but that profile isn't specified in `docker compose down`.

So the container still exists but will have the old network id, and when `docker compose up` runs it starts the container but can't find the network.

Either:

1. Remove the container with `docker compose down <profile>`
1. Re-up using `docker compose up --force-recreate` to recreate the container, which will point it at the newly created network. See [#5745](https://github.com/docker/compose/issues/5745#issuecomment-590400979).

A service is dependent on another service in a different profile, eg:

```
    profiles: ["frontend"]
    depends_on:
      db:
        condition: service_started
```

But the db service is not in the `frontend` profile.

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
      db:
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
