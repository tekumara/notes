# prefect kubernetes

## Agent install

Install prefect kube agent:

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

Prefect [will delete jobs](https://github.com/PrefectHQ/prefect/blob/master/src/prefect/agent/kubernetes/agent.py#L384) on completion. Jobs and pods started by the agent that fail before prefect can start in the pod will remain in kubernetes and will not be deleted.

## Dask

The Prefect DaskExecutor creates a prefect-job pod which uses [dask-kubernetes](https://github.com/dask/dask-kubernetes) to start an ephemeral Dask cluster. For more info see [dask-kubernetes](dask-kubernetes.md).

Dask worker Pods that exit cleanly will end up in the `Completed` state and will not be deleted like Prefect jobs (see above).

If the Prefect Job Pod dies and restarts, it will attempt to create a new Dask cluster. The existing dask cluster will still exist executing tasks.

## Issues

k8s sweet spot is stateless, multi-replica, short running workloads that run continuously. Batch jobs are single replica, long-running workloads that run to completion. k8s node scaling or maintenance events will restart Prefect job Pods. When this happens the agent does funny things, see [#3058](https://github.com/PrefectHQ/prefect/issues/3058).

When cancelling a flow, Prefect can leave Kubernetes jobs and pods running.

## Enabling debug logging on the agent

Create a configmap:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-toml
data:
  config.toml: |
    [cloud.agent]
    level = "DEBUG"
```

Mount on spec.container in the deployment:

```
       volumes:
       - configMap:
           defaultMode: 420
           name: config-toml
         name: config
```
