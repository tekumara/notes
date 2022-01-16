# prefect kubernetes

## Agent install

Apply prefect kube infra:

```
prefect agent kubernetes install -k "$(PREFECT__CLOUD__API_KEY)" --rbac --label kube | kubectl apply -f -
```

This creates:

- A [Deployment](https://github.com/PrefectHQ/prefect/blob/master/src/prefect/agent/kubernetes/deployment.yaml) of the prefect agent
- A [Role](https://github.com/PrefectHQ/prefect/blob/master/src/prefect/agent/kubernetes/rbac.yaml#L2) with permissions to create, monitor and delete pods
- A [RoleBinding](https://github.com/PrefectHQ/prefect/blob/master/src/prefect/agent/kubernetes/rbac.yaml#L17) which grants the above role to the default service account.

## Jobs

The agent creates Kubernetes [job objects](https://github.com/PrefectHQ/prefect/blob/master/src/prefect/agent/kubernetes/job_spec.yaml). The spec runs the equivalent of:

```
docker run prefecthq/prefect:latest prefect execute flow-run
```

With the following mandatory environment variables:

- `PREFECT__CLOUD__API_KEY`
- `PREFECT__CONTEXT__FLOW_RUN_ID`

The [Dockerfile](https://github.com/PrefectHQ/prefect/blob/master/Dockerfile) calls [entrypoint.sh](https://github.com/PrefectHQ/prefect/blob/master/entrypoint.sh) which installs extra pip packages, and then executes the passed unquoted args.

## Dask

The Prefect DaskExecutor creates a prefect-job pod which uses [dask-kubernetes](https://github.com/dask/dask-kubernetes) to start an ephemeral Dask cluster using [KubeCluster](https://kubernetes.dask.org/en/latest/kubecluster.html). This requires additional [kubernetes permissions](https://kubernetes.dask.org/en/latest/kubecluster.html#role-based-access-control-rbac). For more info see [dask-kubernetes](dask-kubernetes.md).
