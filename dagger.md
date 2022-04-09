# dagger

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
If you want to manage docker containers, i recommend using docker
bash is a very lightweight helper on top of docker"

core.#Pull.output` gives you a raw rootfs, not a complete docker image. Image metadata is in another field

If you want the abstraction of a docker image I strongly recommend using `docker.#Pull` and `docker.#Run` instead"

## packaging

"Not sure if it helps with that particular point of confusion, but your `operator` package can access its own source directory without requiring it to be read from `client.filesystem`. This way it can be standalone

You can do this with `core.#Source`

https://github.com/dagger/dagger/blob/main/pkg/universe.dagger.io/netlify/netlify.cue#L64"

## actions

[bash.#Run](https://github.com/dagger/dagger/blob/main/pkg/universe.dagger.io/bash/bash.cue) - will run an existing script or multiple commands stored as a scratch script. Uses [docker.#Run](https://github.com/dagger/dagger/blob/main/pkg/universe.dagger.io/docker/run.cue) to execute inside a docker container.
