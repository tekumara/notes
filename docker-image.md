# docker image

- manifest (_application/vnd.docker.distribution.manifest.v2+json_) - a list of compressed tarball layers
- manifest list (_application/vnd.docker.distribution.manifest.list.v2+json_) - contain a list of manifests for different platforms

`docker manifest inspect $repo:$tag` shows the [manifest](https://docs.docker.com/engine/reference/commandline/manifest/#manifest-inspect) or [manifest list](https://docs.docker.com/engine/reference/commandline/manifest/#inspect-a-manifest-list) for an image on a remote registry. Use `--insecure` of an HTTP server. `docker buildx imagetools inspect $repo:$tag` but is less flexible (eg: expects oauth tokens).

`docker image inspect` works on uncompressed (aka RootFS) layers stored locally.

Get compressed size of image on remote repository

```shell
docker manifest inspect $repo:$tag | jq '[.layers[].size] | add'
```

Get uncompressed size of local image

```shell
docker image inspect $repo:$tag | jq '.[].Size'
```

Get commands and uncompressed size of each layer

```shell
docker history $repo:$tag
```

Remove image

```
docker image rm ubuntu:16.04
```

Remove all images and build cache

```
docker system prune -a
```

Extract image as tar layers

```
docker save ubuntu:20.04 | tar x -C /tmp/
```

List images sorted by size

```
docker images --format "{{.ID}}\t{{.Size}}\t{{.Repository}}:{{.Tag}}" | sort -k 2 -h
```

## References

- [Explaining Docker Image IDs](https://windsock.io/explaining-docker-image-ids/)
