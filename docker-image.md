# docker image

## Digests

[Digests](https://github.com/opencontainers/image-spec/blob/main/descriptor.md#digests) are content-addressable identifiers. They are typically a sha256 hash of their contents.

Locally, image layers are stored uncompressed. Remotely they are compressed. So their digests will be different. Remote digests are sometimes referred to as [distribution](https://github.com/opencontainers/distribution-spec) digests.

## Manifests

An image [manifest](https://github.com/opencontainers/image-spec/blob/main/manifest.md) document contains a list of compressed tarball layers plus a reference to an image document in the `config` field. It's type is _application/vnd.docker.distribution.manifest.v2+json_.

A manifest list is a list of manifests, usually for different platforms. It's type is _application/vnd.docker.distribution.manifest.list.v2+json_.

`docker manifest inspect $repo:$tag` shows a manifest or manifest list for an image on a remote registry. Use `--insecure` for an HTTP server. It's json pretty printed, so its not identical to the actual manifest blob and can't be used to calculate the manifest digest.

- [Example manifest](https://docs.docker.com/engine/reference/commandline/manifest/#inspect-an-images-manifest-object)
- [Example manifest list](https://docs.docker.com/engine/reference/commandline/manifest/#inspect-a-manifest-list)

### Manifest digest

A manifest digest is the hash of an image's manifest json blob stored in the remote registry. This is also called the image digest, which is shorthand for the image's manifest digest. ie: the manifest digest = image digest = `crane manifest repo:tag | sha256sum`

`docker pull` shows manifest digests, as does Docker Hub in its web UI.

Show the manifest digest for an image, or for a manifest list and all its images, on a remote registry:

```
docker buildx imagetools inspect $repo:$tag
```

Show local image digests, ie: the content addressable sha of the image manifest from the remote registry:

```
docker images --digests
```

## Image config

A docker [image config document](https://github.com/moby/moby/tree/master/image/spec) (aka image config) is a set of execution parameters (`config`), a list of **uncompressed** root filesystem layers (`rootfs`), commands that made the layers (`history`) and some metadata.

A local docker image ID is a digest that uniquely identifies a image config document. It's not the same as the manifest digest, which uniquely identifies a [manifest](https://github.com/opencontainers/image-spec/blob/main/manifest.md) document containing **compressed** layers.

There are references between the two documents. A manifest contains the image id/digest in its `config.digest` field, eg: `docker manifest inspect repo:tag | jq .config.digest`. After pulling an image, docker will store the manifest digest in the `RepoDigest` field of its local version of the image config, eg: `docker image inspect data-applications-docker-common.artifactory.xero-support.com/br_orgbizids-prefect:cache | jq '.[].RepoDigests[]'` NB: the `Repo*` fields don't exist in the image config stored on the registry.

`docker push` shows the uncompressed layer digests.

`docker build` shows compressed layer digests when pulling, and the image id when it writes the final image eg:

```
exporting to image
exporting layers done
writing image sha256:0328579a12e62fa3ca8dd3a0d46ef8db6d2effb413f6a4d6a985d5fafae4f5e1 done
```

## Size

Get compressed size of image on remote repository

```shell
docker manifest inspect $repo:$tag | jq '[.layers[].size] | add'
```

Get uncompressed size of local image (local RootFS layers are not compressed):

```shell
docker image inspect $repo:$tag | jq '.[].Size'
```

Get commands and uncompressed size of each layer

```shell
docker history $repo:$tag
```

## Misc

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

- [Structure of an image](https://cloud.google.com/kubernetes-engine/docs/archive/using-container-images#structure_of_an_image)
- [Local images ID does not match registry manifest digest](https://github.com/distribution/distribution/issues/1662#issuecomment-213079540)
- [Explaining Docker Image IDs](https://windsock.io/explaining-docker-image-ids/)
