# dagger

## Getting started

```
brew install dagger/tap/dagger
dagger project init
cat << EOF > dagger.cue
package main

import (
	"dagger.io/dagger"
	"universe.dagger.io/alpine"
	"universe.dagger.io/bash"
)

dagger.#Plan & {
	actions: {
		_alpine: alpine.#Build & {
			packages: bash: _
		}

		hello: bash.#Run & {
			input: _alpine.output
			script: contents: "echo hello world"
		}
	}
}
EOF
dagger project update
dagger do hello --log-format=plain
```

See also [dagger.io: Getting started](https://docs.dagger.io/getting-started)

## config

```
ls ~/.config/dagger/
cli_id        keys.txt      version-check
```

## buildkitd

dagger runs the `moby/buildkit:v0.10.0` container. The buildkit cache is not shared with the host. It is persisted to a `dagger-buildkitd` volume and so will be reused across restarts.

## caching

dagger actions will reuse the cache if dependencies have not changed, eg:

```
$ dagger do test --log-format plain

8:04PM INF client.filesystem.".".read | computing
8:04PM INF client.filesystem.".".read | completed    duration=100ms
8:04PM INF actions.build._build | computing
8:04PM INF actions.build._build | completed    duration=2s
8:04PM INF actions.test._exec | computing
8:04PM INF actions.test._exec | completed    duration=0s
```

The test action was completed in 0s because it's dependencies had not changed.

## parallisation

DAG execution is parallelised. On failure parallel nodes will be cancelled.

## core vs universe

"core are the low-level actions implemented directly by the dagger engine. If they do everything you need, that’s fine, go ahead and use them directly.

Everything else is a “composite” action built on top of core actions (or other composite actions, it’s turtles all the way down 🙂

Everything in universe.dagger.io is composite actions, so you can always look at the cue source, copy, reimplement your own, etc.

A very common package in universe is docker. Unlike core.#Exec, docker.#Run takes a docker.#Image as input
If you want to manage docker containers, i recommend using docker bash is a very lightweight helper on top of docker

`core.#Pull.output` gives you a raw rootfs, not a complete docker image. Image metadata is in another field

If you want the abstraction of a docker image I strongly recommend using `docker.#Pull` and `docker.#Run` instead"

## packaging

"Not sure if it helps with that particular point of confusion, but your `operator` package can access its own source directory without requiring it to be read from `client.filesystem`. This way it can be standalone

You can do this with `core.#Source`

https://github.com/dagger/dagger/blob/main/pkg/universe.dagger.io/netlify/netlify.cue#L64"

## actions

- [alpine.#Build](https://github.com/dagger/dagger/blob/main/pkg/universe.dagger.io/alpine/alpine.cue): build an alpine container with specified packages
- [bash.#Run](https://github.com/dagger/dagger/blob/main/pkg/universe.dagger.io/bash/bash.cue): run an existing script or multiple commands stored as a scratch script.
- [docker.#Run](https://github.com/dagger/dagger/blob/main/pkg/universe.dagger.io/docker/run.cue): run a command in a container. Input is a `docker.#Image`. Used by `bash.#Run`.
- [core.#Exec](https://github.com/dagger/dagger/blob/main/pkg/dagger.io/dagger/core/exec.cue): low-level execution of a command in container. Input is a `dagger.#FS`. Used by `docker.#Run`.
- [git.#Pull](https://github.com/dagger/dagger/tree/main/pkg/universe.dagger.io/git): synonymous with [core.#GitPull]
- [core.#GitPull](https://github.com/dagger/dagger/blob/main/pkg/dagger.io/dagger/core/git.cue): pull from a git remote using buildkit's [llb.Git](https://github.com/dagger/dagger/blob/19c0f99/plan/task/gitpull.go#L84). Does a shallow clone and returns a `dagger.#FS`. `keepGitDir: true` can be used to keep the `.git` directory.
- [core.#Copy](https://github.com/dagger/dagger/blob/main/pkg/dagger.io/dagger/core/fs.cue): copy files from one FS tree to another.
- [docker.#Copy](https://github.com/dagger/dagger/blob/main/pkg/universe.dagger.io/docker/build.cue): copy files into an image.
- [docker.#Dockerfile](https://github.com/dagger/dagger/blob/main/pkg/universe.dagger.io/docker/build.cue): executes a dockerfile sourced from a `dagger.#FS`.

See also:

- [Handling action outputs](https://docs.dagger.io/1228/handling-outputs/)

## types

- [docker.#Image](https://github.com/dagger/dagger/blob/main/pkg/universe.dagger.io/docker/image.cue): a `dagger.#FS` and a `core.#ImageConfig`
- [dagger.#FS](https://github.com/dagger/dagger/blob/main/pkg/dagger.io/dagger/types.cue): reference to a filesystem tree
- [dagger.#Scratch](https://github.com/dagger/dagger/blob/main/pkg/dagger.io/dagger/values.cue): an empty filesystem tree
- [core.#ImageConfig](https://github.com/dagger/dagger/blob/main/pkg/dagger.io/dagger/core/image.cue): container image config including user, entrypoint, volume etc.
- [core.#Ref](https://github.com/dagger/dagger/blob/main/pkg/dagger.io/dagger/core/image.cue): an address for a remote container image, eg: `python:3.9-slim`
- [docker.#Ref](https://github.com/dagger/dagger/blob/main/pkg/universe.dagger.io/docker/image.cue): an address for a remote container image, eg: `python:3.9-slim`. Synonymous with `core.#Ref`.

## client api

See

- [Interacting with the client](https://docs.dagger.io/1203/client)
- [plan.cue](https://github.com/dagger/dagger/blob/main/pkg/dagger.io/dagger/plan.cue)
- [Client API #1597](https://github.com/dagger/dagger/issues/1597)

## misc

- [Package Coding Style](https://docs.dagger.io/1226/coding-style)
