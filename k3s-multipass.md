# k3s multipass

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
