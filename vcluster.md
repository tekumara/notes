# vcluster

Install:

```
curl -s -L "https://github.com/loft-sh/vcluster/releases/latest" | sed -nE 's!.*"([^"]*vcluster-darwin-amd64)".*!https://github.com\1!p' | xargs -n 1 curl -L -o vcluster && chmod +x vcluster;
sudo mv vcluster /usr/local/bin;
```

`vcluster create` will deploy a [helm chart](https://github.com/loft-sh/vcluster/tree/main/charts/k3s) with:

- a [coredns configmap](https://github.com/loft-sh/vcluster/blob/main/charts/k3s/templates/coredns.yaml) and pod
- a vcluster pod with a syncer, and a k3s container
- services for dns and https for the kube apiserver
- a secret containing the vcluster kubeconfig for connecting as admin

Query host kube api for vclusters:

```
vcluster list
```

## Connecting to the cluster

Connect to a vcluster, forwarding the vcluster kube api to a random port on localhost, with kube config written to _kubeconfig.yaml_:

```
vcluster connect vcluster-1
```

_kubeconfig.yaml_ will contain a context called `Default.

Specify where to write kube config:

```
vcluster connect vcluster-1 --kube-config ~/.kube/vcluster.yaml
```

Run command directly against vcluster

```
vcluster connect vcluster-1 -n playlab -- kubectl get pods
```

For more options see [Accessing vcluster](https://www.vcluster.com/docs/operator/accessing-vcluster)
