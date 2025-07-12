# vcluster

## Install

Via brew (but this depends on kubernetes-cli):

```
brew install loft-sh/tap/vcluster
```

Direct install:

```bash
arch=$(uname -sm | awk '{print tolower($1)"-"$2}')
curl -fsS -L "https://api.github.com/repos/loft-sh/vcluster/releases/latest" | jq -r '.assets[].browser_download_url' | grep "vcluster-${arch}$" | xargs -n 1 curl -fLo vcluster
chmod +x vcluster && sudo mv vcluster /usr/local/bin
```

`vcluster create` will deploy a [helm chart](https://github.com/loft-sh/vcluster/tree/main/chart/) with:

- a coredns configmap and pod
- a vcluster pod with a syncer, and a k8s init container
- services for dns and https for the kube apiserver
- a secret containing the vcluster kubeconfig for connecting as admin

k3s was deprecated in [v0.25.0](https://github.com/loft-sh/vcluster/releases/tag/v0.25.0). The default distro is now k8s.

To deploy a vcluster called vcluster without creating a namespace:

```
vcluster create vcluster --create-namespace=false
```

Query host kube api for vclusters:

```
vcluster list
```

## Connect and update current kube context

eg:

```
vcluster connect vcluster
```

If docker is running, this starts the background proxy (ie: kubectl port-forward) on a random port, eg:

```
❯ docker ps
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                                           NAMES
98995bbaa52f   bitnami/kubectl:1.29   "kubectl port-forwar…"   9 seconds ago   Up 8 seconds   0.0.0.0:12446->8443/tcp, [::]:12446->8443/tcp   vcluster_vctest_playlab_mycluster_background_proxy
```

If docker isn't running, port forwarding will happen in the foreground.

The ~first `$KUBECONFIG` file will be updated with `cluster`, `context`, and `user` entries for the vcluster, and `current-context` will be set to the vcluster.

When vcluster disconnects, the `current-context` will be reverted to its previous value. The background proxy is left running.

### Don't update current kube context (recommended)

For more control, [write to a custom kube config file](https://github.com/loft-sh/vcluster/blob/e3c46e68c78610a9cb5b8bf871ab5073165decf0/pkg/cli/connect_helm.go#L165) instead of updating the `$KUBECONFIG` file. We strip out the `current-context` too. This is recommended if using multiple kubeconfig files.

```
vcluster connect vcluster --print | sed '/current-context/d' > ~/.kube/vcluster.yaml
```

NB: see [vcluster --print with port forwarding creates invalid kubeconfig #2889](https://github.com/loft-sh/vcluster/issues/2889)

### Other connect options

Run command directly against vcluster:

```
vcluster connect vcluster -n playlab -- kubectl get pods
```

For more options see [Accessing vcluster](https://www.vcluster.com/docs/operator/accessing-vcluster)

## Upgrade cluster

Upgrade cluster with new vcluster.yaml settings:

```
vcluster create --upgrade vcluster -f vcluster.yaml
```
