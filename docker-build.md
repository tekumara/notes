# docker build

`docker build [-t REPO:TAG] .` will build an image from the Dockerfile in the current directory with tag `REPO:TAG`.

If `-t` is not specified then an image will be built without a `REPO` or `TAG` designation.

Multi-stage builds:

`docker build --target mytarget` will rebuild the `mytarget` image AND any image prior in the Dockerfile, using cached layers if they exist.

## Context

All recursive contents of files and directories in the current directory are sent to the Docker daemon as the build context. Files in the context can be referenced in the Dockerfile [ref](https://docs.docker.com/engine/reference/commandline/build/#build-with-path). To increase the build’s performance, you can exclude files and directories by adding a .dockerignore file see [here](https://docs.docker.com/engine/reference/builder/#dockerignore-file). To build a Dockerfile without a context, [build with -](https://docs.docker.com/engine/reference/commandline/build/#build-with--)

## Dockerfile

See [Dockerfile reference](https://docs.docker.com/engine/reference/builder/) for the instructions that can be used in a Dockerfile. Each instruction creates one layer.

Each instruction in a Dockerfile creates a layer, which is cached. A cached layer is used if the instruction or any context it refers to hasn't changed from when it was created. The files least likely to be changed should be in lower layers, while the files most likely to change should be added last.

"If you have multiple Dockerfile steps that use different files from your context, COPY them individually, rather than all at once. This ensures that each step’s build cache is only invalidated (forcing the step to be re-run) if the specifically required files change" [ref](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

## COPY

When specifying a directory, the directory itself is not copied, just its contents recursively.

eg:

- `COPY src /app/` and `COPY src/ /app/` copy the contents of _src_ to _/app/_
- `COPY . /app/` the contents of the current directory will be copied /app, including directories it contains. Note this will copy the Dockerfile, and so will be recopied everytime the Dockerfile changes which is probably not what you want, so specify individual files/dirs or add the Dockerfile to _.dockerignore_.
- `COPY system.sh /tmp` copy system.sh to the file _/tmp/system.sh_ because _/tmp_ is an existing directory
- `COPY system.sh /tmp/setup` copy system.sh to the file _/tmp/setup_ because _/tmp/setup_ is not an existing directory
- `COPY system.sh /tmp/setup/` copy system.sh to the file _/tmp/setup/system.sh_

`ADD` can untar and download, but prefer `COPY`

Copy from another image:

```Dockerfile
FROM glassechidna/stackit:0.0.39 as stackit
# glibc needed for awscli-v2
FROM frolvlad/alpine-glibc
RUN apk add --no-cache curl make

# install stackit
COPY --from=stackit /usr/bin/stackit /usr/local/bin/stackit
```

## RUN

`RUN script.sh` will run using `/bin/sh` by default so `.bashrc` will be ignored.
Alternatively use the exec form, eg: `RUN ["/bin/bash", "-c", "echo hello"]` or change the shell with the `SHELL` command, see [Dockerfile Reference RUN](https://docs.docker.com/engine/reference/builder/#run)

## Entrypoint vs CMD

[Docker recommends](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#entrypoint) using ENTRYPOINT to set the image’s main command, and then using CMD as default arguments.

The `--entrypoint` flag can be used to override the default entrypoint. A parameter after the image name can be used to override the default CMD.

## Buildkit

[Buildkit](https://github.com/moby/buildkit) was introduced into docker 18.06 as experimental (see [PR #37151](https://github.com/moby/moby/pull/37151)) and is documented [here](https://docs.docker.com/develop/develop-images/build_enhancements/)

Buildkit is enabled by default on Docker Desktop for Mac, and docker compose v2 on linux, but not yet for the [docker cli on linux](https://github.com/moby/moby/issues/40379).

To enable for the docker cli on linux:

```
export DOCKER_BUILDKIT=1
```

Docker compose v1.25.1 or later versions of v1 will need to be told to use the docker cli, and therefore buildkit:

```
export COMPOSE_DOCKER_CLI_BUILD=1
```

When building the output of dockerfile commands will only be shown on an error exit status code. Use `--progress plain` to always show the output of container commands (available since Docker 18.09).

## External build cache

With buildkit enabled, docker build can use another image as its layer cache when building.
[eg:](https://github.com/moby/moby/pull/26839)

```
docker pull myimage:v1.0
docker build --cache-from myimage:v1.0 -t myimage:v1.1 .
=> importing cache manifest from myimage:v1.0

```

or

```
docker build -t test:latest --cache-from test:latest .
=> importing cache manifest from test:latest

```

Multiple cache-from images can be specified.

, and that image can be on a remote registry. For this to work, the image must have cache metadata and the registry must support cache [manifest lists](https://docs.docker.com/registry/spec/manifest-v2-2/#manifest-list), see [this discussion](https://github.com/moby/buildkit/issues/699#issuecomment-432902188). [ECR](https://github.com/aws/containers-roadmap/issues/876) and [Artifactory](https://www.jfrog.com/jira/browse/RTFACT-26179) don't.

> To use an image as a cache source, cache metadata needs to be written into the image on creation. This can be done by setting --build-arg BUILDKIT_INLINE_CACHE=1 when building the image. After that, the built image can be used as a cache source for subsequent builds.

## cache misses between hosts

[tarsum](https://github.com/moby/moby/blob/7b9275c0da707b030e62c96b679a976f31f929d3/pkg/tarsum/tarsum_spec.md) is the checksum Docker uses on files in the tar archives that make up its layers. Caching is invalidated when a file's tarsum changes.

tarsum v1 [does not include mtime](https://github.com/moby/moby/pull/12031) but does include [file mode](https://pkg.go.dev/os#FileMode) with [permission bits](https://github.com/moby/moby/issues/32816#issuecomment-910030001), size and xattrs excluding [SELinux xattrs](https://github.com/moby/buildkit/issues/1330). See [Headers](https://github.com/moby/moby/blob/7b9275c0da707b030e62c96b679a976f31f929d3/pkg/tarsum/tarsum_spec.md#headers) or the buildkit implementation [here](https://github.com/moby/buildkit/blob/b9c4e0b3024fccdf9ced8b38a1adecf6dbf84eab/cache/contenthash/filehash.go#L15) for the full list.

tarsum v1 also includes uid and gids, but Docker will [normalise uid and guid](https://github.com/docker/cli/pull/513L309) to 0:0 in the tar archive so these don't matter.

To view perms, uid, guid, size, mtime, name use `ll` or

```
# linux
stat -c '%A %u %g %s %Y %n' *

# macos
stat -f '%Sp %u %g %z %m %N' *
```

git [does not track](https://git.wiki.kernel.org/index.php/ContentLimitations) mtime or file permissions, except for the executable bit. The rest of the file permissions will determined by the OS `umask`. umask can differ between hosts, and therefore the cache will be invalidated. There are some workarounds:

- [normalise file permissions before build](https://github.com/moby/moby/issues/32816#issuecomment-910030001)
- [normalise perms, mtime etc. in Dockerfile](https://gist.github.com/kekru/8ac61cd87536a4355220b56ae2f4b0a9)

References:

- discussion on [#34715](https://github.com/moby/moby/issues/34715#issuecomment-637383104)

## docker buildx

[docker buildx](https://docs.docker.com/engine/reference/commandline/buildx/) offers the extended capabilities of buildkit that are otherwise available via [buildctl](https://github.com/moby/buildkit).

Buildx has [two export modes](https://github.com/moby/buildkit/issues/752):

- `type=registry,mode=max`: export all layers of all intermediate steps in multi-stage builds
- `mode=min`: export layers for the resulting images and only metadata for the intermediate steps (which is somewhat useful)

https://github.com/docker/buildx

## Troubleshooting

### failed to create LLB definition: base name (${MY_ARG}) should not be blank

Make sure the ARG is specified at the top of the file, and if it doesn't have a default value then supply one on the command line with `--build-arg MY_ARG=...`
