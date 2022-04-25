# dind

To run the docker daemon in a docker container interactively:

```
dr --rm -it --privileged --entrypoint sh docker:dind

# start daemon
dockerd &> /var/log/dockerd.log &

# check its running
docker info

# pull and run hello-world image
docker run hello-world

# list images this daemon knows about
docker images
```

## Images

The docker daemon will store images in _/var/lib/docker/image/overlay2/_. See _/var/lib/docker/image/overlay2/repositories.json_ for a list of the images. _/var/lib/docker_ is a volume on the host, separate from the primary docker daemon. Therefore docker images for the dind container are isolated from the primary docker daemon.

### To configure dockerd to use a local registry

Untested - see https://github.com/docker-library/docker/issues/38#issuecomment-529049778

## References

The [flyte sandbox](https://github.com/flyteorg/flyte/blob/2438f30f3c94c49866eefd992937fec8bea9718e/docker/sandbox/flyte-entrypoint-dind.sh#L22) is an example of a dind container which runs k3s.
