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

Connect to a vcluster, forwarding the vcluster kube api to a random port on localhost, and update the first `$KUBECONFIG` file whilst running:

```
vcluster connect vcluster-1
```

When running, `$KUBECONFIG` file will be updated with `cluster`, `context`, and `user` entries for the vcluster, and `current-context` will be set to the vcluster. When `vcluster connect` exists, these will be removed and `current-context` will be reverted to its previous value.

Instead of updating the `$KUBECONFIG` file, write to a custom kube config file, with a custom context:

```
vcluster connect vcluster-1 --kube-config ~/.kube/vcluster.yaml --kube-config-context-name vcluster --update-current=false
```

Run command directly against vcluster

```
vcluster connect vcluster-1 -n playlab -- kubectl get pods
```

For more options see [Accessing vcluster](https://www.vcluster.com/docs/operator/accessing-vcluster)

NB: vcluster doesn't play nice when the first `$KUBECONFIG` file is a [dummy file used to create a per-shell context](https://github.com/ahmetb/kubectx/issues/12#issuecomment-557852519). Instead it updates the last file, but doesn't restore it on exit. Write to a custom kube config file instead.
