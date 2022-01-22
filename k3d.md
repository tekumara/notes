# k3d

## k3s

[k3s](https://k3s.io/) is a lightweight Kubernetes distribution with low resource requirements, eg: it doesn't use [resource hungry etcd](https://github.com/etcd-io/etcd/issues/11460). It's great for creating lots of disposable development clusters.

The main limitation is it doesn't share its host's local image registry ([see below](#local-image-registry)) so it has a separate image cache and requires extra steps to access locally built images.

It can be run using [k3d](https://github.com/rancher/k3d) (recommended) or multipass or [docker-compose](https://github.com/k3s-io/k3s/blob/master/docker-compose.yml) (see [also](https://gitlab.com/mur-at-public/kube)).

## k3d usage

k3s can be run inside a docker container using k3d

Install:

- macOS: `brew install k3d`
- ubuntu: `curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash`

Create a single node cluster with the default name (`k3s-default`), add a new context (`k3d-k3s-default`) to _~/.kube/config_ and switch to it:

```
k3d cluster create


# creates a server node and a loadbalancer node that forwards the kube api
docker ps
CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS          PORTS                             NAMES
752364b04dec   rancher/k3d-proxy:v4.4.7   "/bin/sh -c nginx-pr…"   15 minutes ago   Up 15 minutes   80/tcp, 0.0.0.0:59985->6443/tcp   k3d-k3s-default-serverlb
82599fa09c1f   rancher/k3s:latest         "/bin/k3s server --t…"   15 minutes ago   Up 15 minutes                                     k3d-k3s-default-server-0
```

Create a cluster with 1 agent node

```
k3d cluster create --agents 1
```

Create a cluster named foobar and forward loadbalancer port 80 to the host

```
k3d cluster create foobar -p "8081:80@loadbalancer" --wait
```

To write kubeconfig for cluster foobar to _~/.k3d/kubeconfig-foobar.yaml_

```
k3d kubeconfig write foobar
```

To generate kubeconfig for all clusters

```
k3d kubeconfig get --all
```

To merge kubeconfig for all clusters into _~/.kube/config_:

```
k3d kubeconfig merge --all -d
```

To stop cluster

```
k3d cluster stop
```

To delete cluster

```
k3d cluster delete
```

### Local image registry (recommended)

k3s doesn't have access to the host's local image registry. (Kubernetes running in Docker Desktop does and so can share locally built images).

To [run a k3d managed registry](https://k3d.io/v5.2.2/usage/registries/#using-k3d-managed-registries):

```
k3d cluster create $clustername --registry-create $registryname:0.0.0.0:5000
```

This creates a [registry container](https://docs.docker.com/registry/introduction/) on the docker network, and configures your k3d cluster to use it. The `0.0.0.0:5000` exposes the registry on port 5000 of your host. This allows the same registry host:port to be used within the cluster as from your host (which is needed for MacOS in particular).

Within the cluster, reference images in the registry using its name, eg: `registryname:5000/myimage:mytag`

On the host, reference images in the registry:

- by localhost, eg: `localhost:5000/myimage:mytag`
- by registry name, eg: `registryname:5000/myimage:mytag`. Requires `registryname` to be mapped to localhost.

### Image import

Alternatively you can import images into the cluster and avoid the need to run a registry. However, everytime the whole image will be copied so, unlike using a local registry, you want be able to take advantage of skipping already-pushed layers.

To import an image from the local docker-daemon into the foobar k3d cluster:

```
k3d image import myapp:local -c foobar
```

To see images available on the server:

```
docker exec -it k3d-$clustername-server-0 crictl images
```

### Connecting to services in the cluster (docker-for-mac)

Services will be accessible on their external IP, which exists on a Docker bridge network. Unfortunately this bridge network isn't [accessible from a macOS host](https://docs.docker.com/docker-for-mac/networking/#per-container-ip-addressing-is-not-possible) because the docker daemon is run inside a VM.

Only the ports published will be accessible from the macOS host. In this example, you can see that only port 6443 (the api-server) is published to the mac host port 59985:

```
CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS          PORTS                             NAMES
752364b04dec   rancher/k3d-proxy:v4.4.7   "/bin/sh -c nginx-pr…"   25 minutes ago   Up 25 minutes   80/tcp, 0.0.0.0:59985->6443/tcp   k3d-k3s-default-serverlb
82599fa09c1f   rancher/k3s:latest         "/bin/k3s server --t…"   25 minutes ago   Up 25 minutes                                     k3d-k3s-default-server-0
```

Additional node ports can be published at the time of cluster creation, eg: to map the ingress port on the loadbalancer -> macOS host port 8081

```
k3d cluster create -p "8081:80@loadbalancer"
```

k3s installs the traefik loadbalancer. Ingress objects with hosts of the form `myapp.k3d.localhost` will be accessible from the macOS on the host mapped port in a web browser, eg: `http://myapp.k3d.localhost:8081/`. This works because Chrome and Firefox resolve \*.localhost to 127.0.0.1 (NB: the default MacOS resolver does not so curl to \*.localhost will fail).

For more info see [Exposing Services](https://k3d.io/v5.2.2/usage/exposing_services/)

#### Exposing ports after cluster creation

There are some tricks to expose ports of a running container via forward, after the cluster has been created, see [#89](https://github.com/rancher/k3d/issues/89)

Alternatively stop the cluster, modify the published ports, then start it again, see [this comment](https://github.com/docker/docker.github.io/issues/4942#issuecomment-435861800).

Hopefully this will be easier in the future when [#6](https://github.com/rancher/k3d/issues/6) is resolved.

## kubelet

k3s runs kubelet with [these args](https://github.com/k3s-io/k3s/blob/master/pkg/daemons/agent/agent_linux.go#L62). On startup the kubelet args will also be written to the k3s logs.

## logs

`docker logs -t k3d-clustername-server-0`

### Troubleshooting

#### listen tcp 0.0.0.0:6443: bind: address already in use

This will occur if you are already running an API server, eg: Docker Desktop.
Specify an alternate port, eg: `k3d cluster create --api-port 6444`

#### ErrImagePull after k3d image import using latest tag

See [#920](https://github.com/rancher/k3d/issues/920)

#### Unable to connect to the server: dial tcp: lookup host.docker.internal

`host.docker.internal` is not resolving on the MacOS host, but is specified in the kubeconfig. Update the kubeconfig to use 127.0.0.1 instead of `host.docker.internal`. See [#927](https://github.com/rancher/k3d/issues/927)

#### Insufficient cpu

Each node runs as a docker container without resource constraints and so has access to all CPUs.
A single node can allocate pods with CPU requests up to the number of CPUs.
If CPU requests > number of CPUs then you scheduling will fail with `Insufficient cpu`.
To resolve, you add an additional node which will double the allocatable CPU (even though you aren't actually increasing the number of actual CPUs).
