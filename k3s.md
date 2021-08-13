# k3s

[k3s](https://k3s.io/) is a lightweight Kubernetes distribution with low resource requirements, eg: it doesn't use [resource hungry etcd](https://github.com/etcd-io/etcd/issues/11460). It's great for creating lots of disposable development clusters.

The main limitation is it doesn't share its host's local image registry ([see below](#local-image-registry)) so images aren't cached, and it requires extra steps to access locally built images.

It can be run using k3d or multipass or [docker-compose](https://gitlab.com/mur-at-public/kube).

## k3d (recommended)

k3s can be run inside a docker container using k3d

Install:

```
brew install k3d
```

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
k3d cluster create foobar -p "8081:80@loadbalancer"
```

To generate kubeconfig for all clusters

```
k3d kubeconfig get --all
```

To stop cluster

```
k3d cluster stop
```

To delete cluster

```
k3d cluster delete
```

### Local image registry

k3s doesn't have access to the host's local image registry. Kubernetes running in Docker Desktop does and so can share locally built images.

To import an image from the local docker-daemon into the default k3d cluster:

```
k3d image import myapp:latest
```

Alternatively you could [run a registry](https://k3d.io/usage/guides/registries/#using-a-local-registry):

```
k3d cluster create NAME --registry-create
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

For more info see [Exposing Services](https://k3d.io/usage/guides/exposing_services/)

#### Exposing ports after cluster creation

There are some tricks to expose ports of a running container via forward, after the cluster has been created, see [#89](https://github.com/rancher/k3d/issues/89)

Alternatively stop the cluster, modify the published ports, then start it again, see [this comment](https://github.com/docker/docker.github.io/issues/4942#issuecomment-435861800).

Hopefully this will be easier in the future when [#6](https://github.com/rancher/k3d/issues/6) is resolved.

### Troubleshooting

#### listen tcp 0.0.0.0:6443: bind: address already in use

This will occur if you are already running an API server, eg: Docker Desktop.
Specify an alternate port, eg: `k3d cluster create --api-port 6444`

## multipass

k3s can be installed on a multipass Ubuntu VM. You will need a way to copy images built on your host and multipass.

Either:

- (recommended) use https://github.com/matti/k3sup-multipass which runs k3s via `multipass shell`.
- create a multipass instance with an ssh key, then run k3sup

eg:

```
k3sup-multipass create flyte
export KUBECONFIG=$(k3sup-multipass kubeconfig flyte)
```

To merge a kube config file generated from k3sup-multipass with ~/.kube/config:

```
sed -i '' 's/default/k3s-test/' ~/.kube/k3s-multipass-test
mv ~/.kube/config ~/.kube/config.old
(KUBECONFIG=~/.kube/config.old:~/.kube/k3s-multipass-test && kubectl config view --flatten > ~/.kube/config)
```

## multipass vs k3d

Multipass can start/stop a VM quickly, although not as quickly as k3d does a container (eg: 12 secs vs 1 sec).
k3d offers an option to copy images from the host to the k3s server, ie: `k3d image import`
Multipass VMs run on a bridged network accessible from the macOS host, so port publishing isn't required. This makes for a simpler network setup.
