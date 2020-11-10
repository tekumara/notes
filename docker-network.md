# Docker network

`docker network ls` list  
`docker network inspect bridge` to see subnet and IP address for network _bridge_  
`docker network rm bridge` to remove network _bridge_  
`docker network prune` to remove unused networks
`docker network connect NETWORK CONTAINER` add additional network to a container
`docker inspect -f '{{ json .NetworkSettings }}' CONTAINER | jq .` network settings including exposed ports and bridged IP address

The default networks are:

```
NETWORK ID          NAME                DRIVER              SCOPE
d4f2926e878e        bridge              bridge              local
5fe1426195d5        host                host                local
36ae9224d2cb        none                null                local
```

Drivers:

none = disables all networking
host = uses the host IP/ports
bridge = a separate network interface with its own subnet. The default when no network is specified. Containers on different bridge networks can't communicate.

On the Linux host running the docker daemon, the default bridge network interface is _docker0_. For user-defined bridge networks, Docker will creates interfaces prefixed with _br-_.

Networks persist after a container is stopped and over machine restarts. If created using docker compose, they can be removed by `docker-compose down`.

To prevent docker from using a subnet, create a dummy one with a tight mask ([ref](https://github.com/moby/moby/issues/21776#issuecomment-222325610)), eg:
`docker network create --subnet 172.19.0.0/24 reserved-172-19-0-0-24`

## Docker for Mac considerations

Docker for Mac runs the docker daemon inside a LinuxKit VM. The docker bridge networks (eg: bridge0) exist on the Linux host running the docker daemon, and are not reachable from the macOS host.

In order to reach docker container ports they have to be [port forwarded via vpnkit](https://github.com/moby/vpnkit/blob/master/docs/ports.md) to the Mac host. eg: to forward port 80 in the nginx container to the macOS host:

```
docker run -p 8000:80 --name webserver nginx
```

See [Networking features in Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/networking/#known-limitations-use-cases-and-workarounds)
