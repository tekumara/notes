# dask kubernetes

[dask-kubernetes](https://github.com/dask/dask-kubernetes) can create a Dask [KubeCluster](https://kubernetes.dask.org/en/latest/kubecluster.html) consisting of:

- a Pod for the scheduler
- a Service to access the scheduler
- one or more Pods containing dask workers.

## Troubleshooting

## Orphaned dask pods

dask pods can become orphaned when dask kubernetes fails after creating them. It doesn't tidy up.

### Missing dependency kubectl (caused by socket.gaierror: [Errno -2] Name or service not known)

Occurs when KubeCluster [tries to locate](https://github.com/dask/dask-kubernetes/blob/935bcff/dask_kubernetes/utils.py#L60) the dask-root service. If it fails, it assumes it is running outside the cluster and falls back to port-forwarding using kubectl, which requires kubectl.

If it is running inside the cluster it may be attempting to connect to an orphaned service. Make sure pods and services from previous runs have been removed.

### User "system:serviceaccount:default:default" cannot get resource "pods/log" in API group "" in the namespace "default"

RBAC needs to be configured, see the [RBAC](https://kubernetes.dask.org/en/latest/kubecluster.html#role-based-access-control-rbac) section of the docs.

### kubernetes_asyncio.config.config_exception.ConfigException: Invalid kube-config file. Expected key current-context in kube-config

KubeCluster will use the current cluster if running in one, or otherwise will expect a kube-config file. If there is no kube-config file it will produce this error.
