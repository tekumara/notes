# buildkit in kubernetes

Install buildctl: `brew install buildkit`

## [buildx create](https://docs.docker.com/engine/reference/commandline/buildx_create)

Define a [rootless kubernetes builder instance](https://docs.docker.com/engine/reference/commandline/buildx_create/#driver-opt) in the default kube namespace with two replicas:

```
docker buildx create --driver kubernetes --name kubebkd \
    --driver-opt rootless=true --driver-opt replicas=2 \
    --driver-opt requests.cpu=1000m --driver-opt requests.memory=1G \
    --driver-opt limits.cpu=1000m --driver-opt limits.memory=1G
```

A [Kubernetes Deployment](https://github.com/docker/buildx/blob/add4301ed6dc3bdd80375e6f8abd85098a91d351/driver/kubernetes/manifest/manifest.go#L48) is created on first use:

```
docker buildx --builder mybuilder build .
```

To talk to the instance, the docker client execs `buildctl dial-stdio` inside the pod and streams stdin/out.

Watch the build process:

```
kubectl exec -it mybuilder0-57966d47cb-z99fs -- ps -o pid,ppid,time,args
```

Within the buildkitd container:
- Images are stored in _/home/user/.local/share/buildkit/runc-native_
- `buildctl du` will show layers and their size, use `--verbose` to see command used for the layers
- `buildctl build` can be used to manually build

The pods, and their cache, remain until killed.

Delete builder instance which removes the Kubernetes Deployment:

```
docker buildx rm mybuilder
```


## [examples/kubernetes](https://github.com/moby/buildkit/tree/master/examples/kubernetes)

## Pod exec

Create a [pod](https://github.com/moby/buildkit/blob/master/examples/kubernetes/pod.rootless.yaml):

```
kubectl apply -f pod.rootless.yaml
```

Connect via the exec buildctl stdio method:

```
buildctl --addr kube-pod://buildkitd build --frontend dockerfile.v0 --local context=/path/to/dir --local dockerfile=/path/to/dir
```

## Service




## BuildKit CLI for kubectl

Create builder instance in current namespace

```
kubectl buildkit create
```

References

- [vmware-tanzu/buildkit-cli-for-kubectl](https://github.com/vmware-tanzu/buildkit-cli-for-kubectl)
- [YouTube: BuildKit CLI for kubectl: A New Way to Build Container Images](https://www.youtube.com/watch?v=vTh6jkW_xtI)

## See also

- [kim](kim.md)
- [buildkitd.toml](https://github.com/moby/buildkit/blob/master/docs/buildkitd.toml.md) for configuration options
