# flyte

protobuf is used to describe the inputs and outputs of tasks

Data & ML are converging

Fabric for connecting disparate compute (containers, Spark, Flink, AWS Batch etc.)
Schedule and workflow decoupled
Multi-tenant
Multi-cluster
Extensible - can call other services (and protect them with resource pools)

## Install

This will install a k3s cluster in docker (requires privileged mode), using dind (docker in docker) so images can be built and registered directly with the cluster, and then deploy flyte to it.

```
git clone git@github.com:flyteorg/flytesnacks.git
cd flytesnacks

# start ghcr.io/flyteorg/flyte-sandbox:dind
make start

# access flyteconsole
```

Now you can access flyteconsole on [localhost:30081/console](http://localhost:30081/console)

To inspect the k3s cluster:

```
# enter sandbox
docker exec -it flyte-sandbox bash

# watch k3s pods
k3s kubectl get po -A --watch
```

syncresources -

## Install sandbox to existing cluster

```
# install flyte sandbox
kubectl create -f https://raw.githubusercontent.com/lyft/flyte/master/deployment/sandbox/flyte_generated.yaml

# wait 5 mins, until the console comes up
curl http://localhost:30081/console

# install the flytesnacks development workflows
docker run --network host -e FLYTE_PLATFORM_URL='127.0.0.1:30081' lyft/flytesnacks:v0.1.0 pyflyte -p flytesnacks -d development -c sandbox.config register workflows

# follow these instructions https://lyft.github.io/flyte/user/getting_started/examples.html#running-workflows-in-flyte
```

## vs argo

Argo pushes inputs and outputs via stdin/stdout vs Flyte stores them in S3 and metadata in the Data Catalog.

Argo was YAML first, although there is now a Python DSL for Argo.

Argo doesn't have types, and is basically stringly-typed.

Task caching is not well supported in Argo, perhaps because Argo DAGs focus on execution of containers rather than data flow.

Storing Argo DAG history only a recent feature.

## vs airflow

Flyte supports ETL workloads and was Lyft's response to Airflow limitations including:

- multi-tenancy (ie: different workloads can run in different namespaces, rather than having ML and ETL jobs share scheduler resources)
- multi-repo / multi-container
- enhanced interactivity (UI and APIs for triggering)
- DAG versioning (ie: multiple versions of the same DAG can run with different inputs and on different schedules)
- Task caching as a first-class feature

## vs kubeflow pipelines

caches artifacts
