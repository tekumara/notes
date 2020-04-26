# k3s

## k3d (recommended)

k3s can be run inside a docker container using k3d

Install:
```
brew install k3d
```

Create a single node cluster called k3s-default will no memory restrictions:
``` 
k3d create
export KUBECONFIG="$(k3d get-kubeconfig --name='k3s-default')"
```

### Local image store

k3s doesn't have access to the host's local image store. Docker Desktop and k8s do and so can share locally built images.

To import an image from the local docker-daemon into the default k3d cluster:
```
k3d import-images myapp:latest
```

Alternatively you could [run a registry](https://github.com/rancher/k3d/blob/master/docs/registries.md), although it's more work.

### Connecting to services in the cluster (docker-for-mac)

Services will be accessible on their external IP, which exists on a Docker bridge network. Unfortunately this bridge network isn't [accessible from a macOS host](https://docs.docker.com/docker-for-mac/networking/#per-container-ip-addressing-is-not-possible) because the docker daemon is run inside a VM.

k3d runs a container for each node, eg:
```
$ k3d create --workers 1
...
$ docker ps
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS              PORTS                    NAMES
232a075bcf91        rancher/k3s:latest       "/bin/k3s agent"         3 seconds ago       Up 1 second                                  k3d-k3s-default-worker-0
0c839920fd2a        rancher/k3s:latest       "/bin/k3s server --h…"   3 seconds ago       Up 2 seconds        0.0.0.0:6443->6443/tcp   k3d-k3s-default-server
```

Only the ports published will be accessible from the macOS host. In the above example, you can see that port 6443 (the api-server) is published.

Additional node ports can be published at the time of cluster creation, eg: to forward macOS host port 8000 -> the server's port 80  
```
k3d create -p 8000:80
```

There are some tricks to expose ports of a running container via forward, after the cluster has been created, see [#89](https://github.com/rancher/k3d/issues/89)

Alternatively stop the cluster, modify the published ports, then start it again, see [this comment](https://github.com/docker/docker.github.io/issues/4942#issuecomment-435861800).

Hopefully this will be easier in the future when [#6](https://github.com/rancher/k3d/issues/6) is resolved. 

### Troubleshooting

#### listen tcp 0.0.0.0:6443: bind: address already in use

This will occur if you are already running an API server, eg: Docker Desktop.
Specify an alternate port, eg: `k3d create --api-port 6444`

## multipass

k3s can be installed on a multipass Ubuntu VM. You will need a way to copy images built on your host and multipass.

Either:
* (recommended) use https://github.com/matti/k3sup-multipass which runs k3s via `multipass shell`
* create a multipass instance with an ssh key, then run k3sup

To merge a kube config file generated from k3sup-multipass with ~/.kube/config:

```
sed -i '' 's/default/k3s-test/' ~/.kube/k3s-multipass-test
mv ~/.kube/config ~/.kube/config.old
(KUBECONFIG=~/.kube/config.old:~/.kube/k3s-multipass-test && kubectl config view --flatten > ~/.kube/config)
```