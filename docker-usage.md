# Docker Usage

`CONTAINER` = id or name

`docker ps` running containers  
`docker ps -a` list all containers (not just running ones)  
`docker ps -lq` show the latest created container id  
`docker images` list of images  
`docker inspect CONTAINER` see details of a container, eg: path & args of the command, network ports, env, mounts
`docker inspect -f '{{.State.Pid}}' CONTAINER` get the PID of the process running in docker  
`docker inspect -f '{{.HostConfig.Memory}}' CONTAINER` to see the container memory limit in bytes  
`docker inspect -f '{{ json .NetworkSettings }}' CONTAINER | jq .` network settings including exposed ports and bridged IP address  
`docker image inspect REPO:TAG` see details of an image  
`docker image inspect python:3.6-slim | jq '.[0].Size'` see size of image
`docker exec -it CONTAINER --user root bash` start a shell inside a running container, as the root user  
`docker logs -f CONTAINER` tail logs  
`docker run -it --name mycontainer IMAGE [COMMAND]` create and start a new container from an image ([ref](https://docs.docker.com/engine/reference/run/)). To use the image's default command, omit `command`. `-it` is for interactive sessions (keep stdin open and start a psuedo-tty)  
`docker run --rm -it -v $(pwd):/app -w /app IMAGE /bin/bash` run a shell in the image with the current directory mounted  
`docker run -d IMAGE [COMMAND]` create and start a new container from an image, then detach and leave it running in the background  
`docker run -it --entrypoint COMMAND --user root IMAGE` to override the entrypoint with an interactive command, and run as root  
`docker run -d --rm --name myapp IMAGE [COMMAND]` create and start a new container from an image, give it the name myapp, then detach and leave it running in the background. When the container is stopped it will be removed  
`docker start -i CONTAINER` start (or attach to running) container with an interactive session  
`docker stop CONTAINER` stop container  
`docker run -d --name gmetad1 -p 0.0.0.0:7001:80 -v /tmp/ganglia:/var/lib/ganglia gmetad-gangliaweb` create and start a new container, mapping host:7001 -> container:80 and mounting the host directory /tmp/ganglia at /var/lib/ganglia inside the container  
`docker run --rm -it -e TERM=xterm-256color -e USER=ada.lovelaceubuntu:18.04` run container and set the env vars USER and TERM
`docker build -t REPO:TAG .` build an image from the Dockerfile in the current directory with tag REPO:TAG. All files in the current directory are tar'd and sent to the Docker daemon  
`docker cp <containerId>:/file/path/within/container /host/path/target` copy file or directory from container to the host  
`sudo nsenter -t PID -n netstat -tanp` run netstat inside the namespace of process PID (which is running in a container) [ref](https://stackoverflow.com/a/40352004/149412)
`docker stats --format "table {{printf \"%.25s\" .Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}" --no-stream` show relevant stats, truncating the name because it can be long

`docker ps --format "table {{.Image}}\t{{.Ports}}\t{{.Names}}"` containers with nicer formatting
`docker container rm CONTAINER` remove container
`docker network connect NETWORK CONTAINER` add additional network to a container
`docker inspect CONTAINER | jq '.[].HostConfig.RestartPolicy'` check [restart policy](https://docs.docker.com/config/containers/start-containers-automatically/)
`docker update --restart no CONTAINER` set restart policy to default of no, so the container doesn't start when the daemon starts up

`docker context ls` show current docker host

## Modify existing container config

Docker stores container metadata in `/var/lib/docker/containers/[CONTAINER_ID]/`. On a Mac, Docker runs as an LinuxKit xhyve process. You need to connect to that first and then proceed to modify the container metadata ([ref](https://www.softwareab.net/wordpress/docker-macosx-modify-hostconfig-existing-container/))

## Image size

`docker manifest inspect` works on compressed tarballs stored on the registry.
`docker image inspect` works on uncompressed (aka RootFS) layers stored locally.

Get compressed size of image on remote repository

```
docker manifest inspect $repo:$tag | jq '[.layers[].size] | add'
```

Get uncompressed size of local image

```
docker image inspect $image | jq '.[].Size'
```

Get commands and uncompressed size of each layer

```
docker history $image
```

## Troubleshooting

### ERROR: error while removing network: network X id Y has active endpoints

Stop any containers using the network before trying to delete it.

### ^C doesn't quit cleanly

The docker container's entrypoint needs to handle SIGINT command to quit cleanly.

Use `/bin/bash` or [tini](https://github.com/krallin/tini) as an entrypoint for programs that don't (eg: `make`). Or use docker compose `init: true` to install tini.
