# gitops

Inverts operations by making the cluster reconcile resources from a single source of truth (typically git, but could be S3).

- Homogenised - each repo declares the infra it needs deployed rather than how to deploy it. Avoids heterogeneous repo-specific pipelines.
- Scaled - multiple clusters will pull from a single source of truth, rather than a CI system pushing out. Good for many clusters on the edge.
- Network access - does not require ingress to the cluster. Instead the cluster reaches out.

Examples:
- [Config Sync](https://cloud.google.com/anthos-config-management/docs/config-sync-overview)
- [Fleet](https://fleet.rancher.io/) - [designed to scale](https://twitter.com/ibuildthecloud/status/1313902030046425089?s=20&t=h9tI8pTParuaV8-BQ6w4iw) to [a million edge clusters](https://www.suse.com/c/rancher_blog/scaling-fleet-and-kubernetes-to-a-million-clusters/).
- [Flux](https://github.com/fluxcd/flux)
- [Keel](https://github.com/keel-hq/keel)
- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)
