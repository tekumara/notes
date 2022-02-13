# k3d

## k3s

[k3s](https://k3s.io/) is a lightweight Kubernetes distribution with low resource requirements, eg: it doesn't use [resource hungry etcd](https://github.com/etcd-io/etcd/issues/11460). It's great for creating lots of disposable development clusters.

The main limitation is it doesn't share its host's local image registry ([see below](#local-image-registry)) so it has a separate image cache and requires extra steps to access locally built images.

It can be run using [k3d](https://github.com/rancher/k3d) (recommended) or multipass or [docker-compose](https://github.com/k3s-io/k3s/blob/master/docker-compose.yml) (see [also](https://gitlab.com/mur-at-public/kube)).

k3d may have a slightly [older version of k3s](https://github.com/rancher/k3d/blob/main/version/version.go#L41).

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

To create a cluster with the latest version of k3s:

```
k3d cluster create $clustername -i latest
```

To add two agent nodes after cluster creation:

```
k3d node create -c $clustername [-i image] --replicas 2 mynewagents
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

## Networking

### Service LoadBalancer

k3s implements Service objects of type LoadBalancer using klipper. For each LoadBalancer resource, k3s runs [klipper](https://github.com/k3s-io/klipper-lb) as a `svclb-servicename` DaemonSet in the kube-system namespace. klipper uses [iptables](https://github.com/k3s-io/klipper-lb/blob/master/entry) to forward any requests to the Service's port on that node to the Service's cluster ip and port.

### Ingress

k3s uses traefik as the [ingress controller](https://rancher.com/docs/k3s/latest/en/networking/#traefik-ingress-controller). It is deployed via helm. A Service of type LoadBalancer is configured for traefik in the kube-system namespace. To inspect this service:

```
kubectl get service -n kube-system traefik -o yaml
```

The traefik Service (using klipper) will forward ports 80 and 443 on any node to the web (8000) and websecure (8443) target ports of the traefik pod.

See

- k3d docs: [servicelb (klipper-lb)](https://k3d.io/v5.2.2/usage/k3s/#servicelb-klipper-lb)
- k3s docs: [Service Load Balancer](https://rancher.com/docs/k3s/latest/en/networking/#service-load-balancer)

### k3d proxy (serverlb) for connecting to services in the cluster

Services will be accessible on their external IP, which exists on a Docker bridge network. This works on Linux, but unfortunately this bridge network isn't [accessible from a macOS host](https://docs.docker.com/docker-for-mac/networking/#per-container-ip-addressing-is-not-possible) because the docker daemon is run inside a VM.

To solve this, k3d creates a nginx proxy container named `k3d-$clustername-serverlb` on the same network as the cluster:

```
docker ps
CONTAINER ID   IMAGE                      COMMAND                  CREATED      STATUS          PORTS                             NAMES
201bdf909726   rancher/k3d-proxy:5.2.2    "/bin/sh -c nginx-pr…"   7 days ago   Up 9 seconds    80/tcp, 0.0.0.0:51470->6443/tcp   k3d-myapp-serverlb
...
```

This container exposes host posts to allow access to the cluster from the host. In the k3d [documentation](https://k3d.io/v5.2.2/design/defaults/#k3d-loadbalancer) and [code](https://github.com/rancher/k3d/blob/0b4c4d51aaa59c26595cf54dd8f9124a5ffbb709/pkg/types/loadbalancer.go#L25) this is referred to as the load balancer, or serverlb.

By default only 6443 (the kube api-server) is exposed on a random host port (in this example host port 51470). Additional host ports can be mapped at the time of cluster creation, eg: to map host port 8081 -> port 80 (ingress) on all nodes in the cluster

```
k3d cluster create $clustername -p "8081:80@servers:*;agents:*"
```

Port mappings default to proxy ports. A proxy port is created on the serverlb container and will:

- create a nginx listener on the container port, with an upstream targeting the containers in the node filter
- expose a host port mapped to the listener port

The node filter describes which node containers to route to. The following are equivalent and target all node containers in the cluster:

- `-p "8081:80@servers:*:proxy;agents:*:proxy"`
- `-p "8081:80@servers:*;agents:*"`
- `-p "8081:80@loadbalancer"`
- `-p "8081:80"`

The nginx conf is in _/etc/nginx/nginx.conf_ and is generated by a [confd template](https://github.com/rancher/k3d/blob/main/proxy/templates/nginx.tmpl) using the values in _/etc/confd/values.yaml_.

To inspect the nginx config:

```
docker exec -it k3d-$clustername-serverlb cat /etc/nginx/nginx.conf
```

Ports can be mapped directly rather than via the loadbalancer proxy using the suffix `direct` in a node filter. Unlike proxy ports, these cannot be changed after the cluster has been created.

See

- [v5.0.0 release notes](https://github.com/rancher/k3d/blob/5a00a39323ee8d72da17b112afd86444b3cc4b30/CHANGELOG.md#v500) which describe the node filter syntax
- [k3d Loadbalancer](https://k3d.io/v5.2.2/design/defaults/#k3d-loadbalancer)
- [rancher/k3d-proxy](https://registry.hub.docker.com/r/rancher/k3d-proxy)

#### Exposing ports after cluster creation

Docker doesn't allow adding ports to running containers. Containers have to be modified/recreated and restarted with the new ports. k3d can facilitate recreation of the serverlb. NB: other nodes have state so [recreating them breaks the cluster](https://github.com/rancher/k3d/issues/89#issuecomment-990695777).

See:

- [cluster edit](https://github.com/rancher/k3d/pull/670) to modify the serverlb container
- [node edit](https://github.com/rancher/k3d/pull/615) for nodes (but should only be used on the serverlb node)

To expose port 80 in the cluster (ie: the traefik service) as host 8080:

```
k3d cluster edit $clustername --port-add 8080:80@loadbalancer
```

Alternatives

- stop the container, modify the published ports, then start it again, see [this comment](https://github.com/docker/docker.github.io/issues/4942#issuecomment-435861800).
- [#89](https://github.com/rancher/k3d/issues/89) for a solution using an additional socat container.

Discussion

- [#6](https://github.com/rancher/k3d/issues/6)

### Exposing services via Ingress

k3s installs the traefik ingress controller. Ingress objects can use virtual hosts.

If your DNS resolver resolves \*.localhost to 127.0.0.1, you can use these as virtual hosts in the Ingress object. Linux, Chrome and Firefox will all resolve \*.localhost to 127.0.0.1. (NB: the default MacOS resolver does not so curl to \*.localhost will fail).

For example, if you have:

1. A myapp Service
1. An Ingress rule for host `myapp.k3d.localhost` to the myapp Service
1. The port mapping `-p 8081:80@loadbalancer` on your cluster
1. And your host resolves \*.localhost to 127.0.0.1

Then [http://myapp.k3d.localhost:8081/](http://myapp.k3d.localhost:8081/) on your host will be routed to your Service in the cluster. It looks like this:

docker host port 8081 -> serverlb container port 80 (nginx) -> any node port 80 (traefik service loadbalancer) -> traefik pod port 8000 (traefik)

For more info see [Exposing Services](https://k3d.io/v5.2.2/usage/exposing_services/)

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
