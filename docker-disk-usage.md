# docker disk usage

A sign you are running out of space in the docker disk image file is apt-get failures:

```
6.111 W: An error occurred during the signature verification. The repository is not updated and the previous index files will be used. GPG error: http://ports.ubuntu.com/ubuntu-ports focal InRelease: At least one invalid signature was encountered.
```

Verify this by checking physical usage (see below)

## Physical usage

### Docker Desktop on Mac

Docker Desktop on Mac stores Linux containers and images in a single large “disk image” file, located at `~/Library/Containers/com.docker.docker/Data/vms/0/data`

`ls -klsh ~/Library/Containers/com.docker.docker/Data/vms/0/data` will show the actual disk usage vs maximum:

```
total 68167208
 68167208 -rw-r--r--  1 tekumara  staff   104G 21 Jun 17:23 Docker.raw
```

Actual usage is 68MB, max is 104G. To increase the max: _Docker - Preferences - Resources - Disk image size_

See [Where does Docker Desktop store Linux containers and images? (Mac)](https://docs.docker.com/desktop/faqs/macfaqs/#where-does-docker-desktop-store-linux-containers-and-images)

### Linux

Containers, images and volumes are stored under _/var/lib/docker/_ (requires sudo).

## Disk usage

`docker system df` will show docker disk utilization summary - images, containers, volumes  
`docker system df -v` a break-down at the individual image/container/volume level including shared size (ie: shared layers), unique size (ie: unique layers).

`docker system df -v | grep $volume` to show size of specific volume or alternatively: `docker run --rm -it -v /:/vm-root alpine du -sHh /vm-root$(docker volume inspect --format '{{ .Mountpoint }}' $volume)`

`docker images --format "{{.ID}}\t{{.Size}}\t{{.Repository}}:{{.Tag}}" | sort -k 2 -h` images sorted by size

[Dangling images](https://docs.docker.com/engine/reference/commandline/images/#show-untagged-images-dangling) are untagged leaf images (ie: not intermediate layers).

`docker images -f dangling=true` list dangling images and their size

Unused images are images that aren't associated with a container (includes all dangling images)

`grep -xvf <(docker ps -a --format '{{.Image}}') <(docker images | tail -n +2 | awk '{ print $1":"$2 }')` unused images

## Pruning

Remove containers:

`docker container prune` remove all stopped containers  
`docker container prune --filter 'until=1440h'` remove all containers created earlier than 60 days ago

After removing containers you can remove their images:

`docker image prune` remove dangling images  
`docker image prune -a --filter 'until=1440h'` remove unused images (dangling or otherwise) created earlier than 60 days ago  
`docker image rm $repo:$tag` remove specific image

Pruning images does not automatically remove them from the build cache. It just removes the tag. So the total reclaimed space can be 0, but the image usage will decrease and the build cache usage will increase. To prune the build cache:

`docker builder prune` remove dangling build cache  
`docker builder prune -a` remove all build cache

Finally unused volumes:

`docker volume prune -a` remove all (ie: anonymous and named) unused (ie: not referenced by a container) volumes

To remove everything:

`docker system prune` remove all stopped containers (will delete k3d clusters not running!), unused networks, dangling images, dangling build cache objects  
`docker system prune --volumes` remove above + volumes associated with the stopped containers  
`docker system prune -a` remove all stopped containers, unused networks, unused images, and the whole build cache  
`docker system prune -a --volumes` above + volumes too

### Recommended cleanup

To remove most things, keeping images and containers built in the last 60 days:

```
docker container prune --filter 'until=1440h'
docker image prune -a --filter 'until=1440h'
docker volume prune -a
docker builder prune
```

## Docker desktop logs

Check the logs dir for excessive usage:

```
du -ksh ~/Library/Containers/com.docker.docker/Data/log
```

And remove it if needed

```
rm -rf ~/Library/Containers/com.docker.docker/Data/log
```
