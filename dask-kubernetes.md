# dask kubernetes

[dask-kubernetes](https://github.com/dask/dask-kubernetes) can create a Dask [KubeCluster](https://kubernetes.dask.org/en/latest/kubecluster.html) consisting of:

- a Pod for the scheduler
- a Service to access the scheduler
- one or more Pods containing dask workers.

This requires additional [kubernetes permissions](https://kubernetes.dask.org/en/latest/kubecluster.html#role-based-access-control-rbac).

## Troubleshooting

List scheduler pod

```
kubectl get pods -l dask.org/component=scheduler
```

List worker pods

```
kubectl get pods -l dask.org/component=worker
```

Tail scheduler logs

```
kubectl logs -l dask.org/component=scheduler -f
```

or

```
stern -l dask.org/component=scheduler --tail 10
```

Port forward dashboard

```
kubectl port-forward svc/dask-root-a31d4f8a-4 8787:8787
```

## Orphaned dask pods

Dask worker Pods that exit cleanly will end up in the `Completed` state and will not be deleted. Kubernetes will eventually [garbage collect them](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-garbage-collection) but the default threshold is 12500 terminated pods, and not likely to be hit. Unfortunately the workers are not Jobs, so the [TTL-after-finished controller](https://kubernetes.io/docs/concepts/workloads/controllers/ttlafterfinished/) will not garbage collection them.

Dask pods can also end up in the `Error` state if they don't [shutdown cleanly](https://github.com/dask/distributed/issues/6261).

### Missing dependency kubectl (caused by socket.gaierror: [Errno -2] Name or service not known)

Occurs when KubeCluster [tries to locate](https://github.com/dask/dask-kubernetes/blob/935bcff/dask_kubernetes/utils.py#L60) the dask-root service. If it fails, it assumes it is running outside the cluster and falls back to port-forwarding using kubectl, which requires kubectl.

If it is running inside the cluster it may be attempting to connect to an orphaned service. Make sure pods and services from previous runs have been removed.

### User "system:serviceaccount:default:default" cannot get resource "pods/log" in API group "" in the namespace "default"

RBAC needs to be configured, see the [RBAC](https://kubernetes.dask.org/en/latest/kubecluster.html#role-based-access-control-rbac) section of the docs.

### kubernetes_asyncio.config.config_exception.ConfigException: Invalid kube-config file. Expected key current-context in kube-config

KubeCluster will use the current cluster if running in one, or otherwise will expect a kube-config file. If there is no kube-config file it will produce this error.

### KeyError: 'clusters'

Occurs when the kubernetes client tries to read a kube-config file that is missing the `clusters` keywords.
