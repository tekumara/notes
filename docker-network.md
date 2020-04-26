# Docker network

`docker network ls` list  
`docker network inspect bridge` to see subnet and IP address for network *bridge*
`docker network rm bridge` to remove network *bridge*
`docker network prune` to remove unused networks

On a Linux host, docker will create virtual interfaces prefixed with `br-*`. They will persist after a container is stopped and over machine restarts, but will be removed by `docker-compose down`.

To prevent docker from using a subnet, create a dummy one with a tight mask ([ref](https://github.com/moby/moby/issues/21776#issuecomment-222325610)), eg:
`docker network create --subnet 172.19.0.0/24 reserved-172-19-0-0-24`

The default networks are
```
NETWORK ID          NAME                DRIVER              SCOPE
d4f2926e878e        bridge              bridge              local
5fe1426195d5        host                host                local
36ae9224d2cb        none                null                local
```

If no network is specified, containers will use the default *bridge* network which has the following options:
```
$ docker network inspect bridge | jq '.[0].Options'
{
  "com.docker.network.bridge.default_bridge": "true",
  "com.docker.network.bridge.enable_icc": "true",
  "com.docker.network.bridge.enable_ip_masquerade": "true",
  "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
  "com.docker.network.bridge.name": "docker0",
  "com.docker.network.driver.mtu": "1500"
}
```

