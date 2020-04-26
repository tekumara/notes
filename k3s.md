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