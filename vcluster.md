# vcluster

`vcluster create` will deploy a [helm chart](https://github.com/loft-sh/vcluster/tree/main/charts/k3s) with:
- a [coredns configmap](https://github.com/loft-sh/vcluster/blob/main/charts/k3s/templates/coredns.yaml) and pod
- a vcluster pod with a syncer, and a k3s container
- services for dns and https for the kube apiserver
