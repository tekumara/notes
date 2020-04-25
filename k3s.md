# k3s

## multipass

k3s can be installed on a multipass Ubuntu VM 

Either:
* (recommended) use https://github.com/matti/k3sup-multipass which runs k3s via `multipass shell`
* create a multipass instance with an ssh key, then run k3sup

To merge a kube config file generated from k3sup-multipass with ~/.kube/config:

```
sed -i '' 's/default/k3s-test/' ~/.kube/k3s-multipass-test
mv ~/.kube/config ~/.kube/config.old
(KUBECONFIG=~/.kube/config.old:~/.kube/k3s-multipass-test && kubectl config view --flatten > ~/.kube/config)
```

## k3d 

k3s can be run inside a docker container using k3d

Install
```
brew install k3d
```

Create a single node cluster called k3s-default will no memory restrictions:
``` 
k3d create
export KUBECONFIG="$(k3d get-kubeconfig --name='k3s-default')"
```

## Troubleshooting

### listen tcp 0.0.0.0:6443: bind: address already in use

This will occur if you are already running an API server, eg: Docker Desktop.
Stop Docker Desktop, or specify an alternate port, eg: `k3d create --api-port 6444`