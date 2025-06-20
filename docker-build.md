# docker build

`docker build [-t REPO:TAG] .` will build an image from the Dockerfile in the current directory with tag `REPO:TAG`.

If `-t` is not specified then an image will be built without a `REPO` or `TAG` designation.

Multi-stage builds:

`docker build --target mytarget` will rebuild the `mytarget` image AND any image prior in the Dockerfile, using cached layers if they exist.

## Context

All recursive contents of files and directories in the current directory are sent to the Docker daemon as the build context. Files in the context can be referenced in the Dockerfile [ref](https://docs.docker.com/engine/reference/commandline/build/#build-with-path). To increase the build’s performance, you can exclude files and directories by adding a .dockerignore file see [here](https://docs.docker.com/engine/reference/builder/#dockerignore-file). To build a Dockerfile without a context, [build with -](https://docs.docker.com/engine/reference/commandline/build/#build-with--)

## Dockerfile

See [Dockerfile reference](https://docs.docker.com/engine/reference/builder/) for the instructions that can be used in a Dockerfile. Each instruction creates one layer.

Each instruction in a Dockerfile creates a layer, which is cached. The cache for a layer is hit if the instruction or any context it refers to hasn't changed since it was created. If there's a miss it'll be rebuilt, along with all the later layers. By keeping files that change the least in earlier layers, and the files that change the most in later layers, you can maximise cache hits and decrease rebuild time.

"If you have multiple Dockerfile steps that use different files from your context, COPY them individually, rather than all at once. This ensures that each step’s build cache is only invalidated (forcing the step to be re-run) if the specifically required files change" [ref](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

## COPY

When specifying a directory, the directory itself is not copied, just its contents recursively.

eg:

- `COPY src /app/` and `COPY src/ /app/` copy the contents of _src_ to _/app/_
- `COPY . /app/` the contents of the current directory will be copied /app, including directories it contains. Note this will copy the Dockerfile, and so will be recopied every time the Dockerfile changes which is probably not what you want, so specify individual files/dirs or add the Dockerfile to _.dockerignore_.
- `COPY system.sh /tmp` copy system.sh to the file _/tmp/system.sh_ because _/tmp_ is an existing directory
- `COPY system.sh /tmp/setup` copy system.sh to the file _/tmp/setup_ if the directory _/tmp/setup/_ doesn't exist, or _/tmp/setup/system.sh_ if it does
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

## BuildKit

[BuildKit](https://github.com/moby/buildkit) was introduced into Docker 18.06 as experimental (see [PR #37151](https://github.com/moby/moby/pull/37151)) and is documented [here](https://docs.docker.com/develop/develop-images/build_enhancements/)

BuildKit is enabled by default on Docker Desktop for Mac, and since docker [v23.0.0](https://github.com/moby/moby/releases/tag/v23.0.0) on linux.

To enable BuildKit for the docker cli on earlier Linux versions:

```
export DOCKER_BUILDKIT=1
```

Docker compose v1.25.1 or later versions of v1 will need to be told to use the docker cli, and therefore BuildKit when enabled:

```
export COMPOSE_DOCKER_CLI_BUILD=1
```

When building the output of dockerfile commands will only be shown on an error exit status code. Use `--progress plain` to always show the output of container commands (available since Docker 18.09).

## Remote build cache

BuildKit supports the following cache exporters:

- `inline` embed the cache into the image, and push them to the registry together (recommended)
- `registry` push the image and the cache separately

When using Buildkit via docker, set `BUILDKIT_INLINE_CACHE=1` to use the inline cache. buildkit will stash the inline cache in the `moby.buildkit.cache.v0` field of the [image config](https://github.com/moby/buildkit/issues/752). The layers are not changed. NB: on a fully cached rebuild, `moby.buildkit.cache.v0` may change, causing the manifest digest to change, see [#3009](https://github.com/moby/buildkit/issues/3009).

Registry caching (aka explicit caching) will push separate layers for the cache. The requires the registry supports cache [manifest lists](https://docs.docker.com/registry/spec/manifest-v2-2/#manifest-list), see [this discussion](https://github.com/moby/buildkit/issues/699#issuecomment-432902188). [ECR](https://github.com/aws/containers-roadmap/issues/876) doesn't and [Artifactory > 7.31.10](https://www.jfrog.com/jira/browse/RTFACT-26179) does. See a more complete list of [cache support here](https://docs.earthly.dev/docs/remote-caching#compatibility-with-major-registry-providers).

Registry caching can optionally use `max` cache mode, which will export all the layers of all intermediate steps (across). Inline caching only supports `min` mode which only exports layers for the final image. See this comparison between [inline and registry/explicit caching](https://docs.earthly.dev/docs/remote-caching#comparison-between-inline-and-explicit-cache).

With BuildKit enabled, docker build can [use another image](https://github.com/moby/moby/pull/26839) as its layer cache when building using the `--cache-from` flag, eg:

```
docker build . --cache-from myapp:latest
=> importing cache manifest from myapp:latest
```

When the `cache-from` image is on a remote registry its layers will be pulled incrementally as needed.

## Cache misses between hosts

[tarsum](https://github.com/moby/moby/blob/99a3969/pkg/tarsum/tarsum_spec.md) is the checksum Docker uses on files in the tar archives that make up its layers. ADD/COPY layers are invalidated when a file's tarsum changes. tarsum is [not used for CMD layers](https://github.com/moby/moby/issues/17863#issuecomment-155443490).

tarsum v1 [does not include mtime](https://github.com/moby/moby/pull/12031) but does include [file mode](https://pkg.go.dev/os#FileMode) with [permission bits](https://github.com/moby/moby/issues/32816#issuecomment-910030001), size and xattrs excluding [SELinux xattrs](https://github.com/moby/buildkit/issues/1330). See [Headers](https://github.com/moby/moby/blob/99a3969/pkg/tarsum/tarsum_spec.md#headers) or the buildkit implementation [here](https://github.com/moby/buildkit/blob/f84058e/cache/contenthash/filehash.go#L15) for the full list.

tarsum v1 also includes uid and gids

- in this PR Docker will [normalise uid and guid](https://github.com/docker/cli/pull/513) to 0:0 in the tar archive so these don't matter.

To view perms, uid, guid, size, mtime, name use `ll` or

```
# linux
stat -c '%A %u %g %s %Y %n' *

# macos
stat -f '%Sp %u %g %z %m %N' *
```

git [does not track](https://git.wiki.kernel.org/index.php/ContentLimitations) mtime or file permissions, except for the executable bit. The rest of the file permissions will be determined by the OS `umask`. umask can differ between hosts, and therefore the cache will be invalidated. There are some workarounds:

- [normalise file permissions before build](https://github.com/moby/moby/issues/32816#issuecomment-910030001)
- [normalise perms, mtime etc. in Dockerfile](https://gist.github.com/kekru/8ac61cd87536a4355220b56ae2f4b0a9)

References:

- discussion on [#34715](https://github.com/moby/moby/issues/34715#issuecomment-637383104)

## Build sources record

Buildkit will store a list of the build sources in the `moby.buildkit.buildinfo.v0` in the image document. See [Build reproducibility](https://github.com/moby/buildkit/blob/master/docs/build-repro.md).

## docker buildx

[docker buildx](https://docs.docker.com/engine/reference/commandline/buildx/) offers the extended capabilities of buildkit that are otherwise available via [buildctl](https://github.com/moby/buildkit). See also [docker/buildx](https://github.com/docker/buildx) on Github. `docker build` -> `docker buildx build` since [docker v23](https://github.com/moby/moby/releases/tag/v23.0.0). However the buildx plugin (which supports additional commands like bake) must be separated installed (eg: `apt-get install docker-buildx-plugin`).

### docker buildx bake

Build the `ci` service in compose file and push:

```
docker buildx bake -f docker-compose.dev.yaml --push ci
```

Using an env file:

```
env $(cat image.env | xargs) docker buildx bake -f docker-compose.yaml --push ci
```

To see the config/dry run use `--print`.

## Troubleshooting

### failed to create LLB definition: base name (${MY_ARG}) should not be blank

Make sure the ARG is specified at the top of the file, and if it doesn't have a default value then supply one on the command line with `--build-arg MY_ARG=...`

## W: GPG error: ... At least one invalid signature was encountered

Can be a lack of disk space. See [docker prune](docker-disk-usage.md#pruning)
