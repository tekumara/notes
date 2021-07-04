# flyte

protobuf is used to describe the inputs and outputs of tasks

Data & ML are converging

Fabric for connecting disparate compute (containers, Spark, Flink, AWS Batch etc.)
Schedule and workflow decoupled
Multi-tenant
Multi-cluster
Extensible - can call other services (and protect them with resource pools)

## Concepts

- [Task](https://docs.flyte.org/en/stable/concepts/tasks.html#divedeep-tasks) - an independent unit of processing, with or without side-effects.
- [Workflow](https://docs.flyte.org/en/stable/concepts/workflows_nodes.html) - a graph of nodes. Defined in protobuf. Workflows can refer to tasks or workflows outside their own project or domain.
- [Nodes](https://docs.flyte.org/en/stable/concepts/workflows_nodes.html) - a node can be a task, another workflow, or a branch node.
- [Launch plans](https://docs.flyte.org/en/stable/concepts/launchplans_schedules.html) are used to execution a workflow. Can specify bound inputs and a [schedule](https://docs.flyte.org/en/stable/concepts/launchplans_schedules.html#schedules). There can be multiple versions of a launch plan, but only one active launch plan and its schedule. Inactive launch plans can still be triggered manually.
- [Projects](https://docs.flyte.org/en/stable/concepts/projects.htm) - a grouping of tasks and workflows. Resources limits can be set per project.
- [Domains](https://docs.flyte.org/en/stable/concepts/domains.html) - used to denote different deployment environments, eg: staging, production.
- [Plugins](https://docs.flyte.org/en/stable/concepts/architecture.html#data-plane) - a plugin handles a type of task, eg: Hive, Spark, AWS Batch etc.

## Architecture

FlyteKit - SDK for describing workflows in python, compiling them to Protobuf, and submission and execution.

[FlyteAdmin](https://docs.flyte.org/en/stable/concepts/admin.html) - serves the main Flyte API over gRPC and HTTP. It processes all client requests from FlyteKit, FlyteConsole, and FlyteCLI. It uses postgres for persistence and launches workflows on the data plane ie: kubernetes

flyteworkflow is a kubernetes CRD which represents the flyte workflow DAG.

FlytePropeller is a kubernetes operator that looks for flyteworkflow CRDs and launches pods to execute them.

[FlyteConsole](https://docs.flyte.org/en/stable/concepts/console.html) - UI for viewing workflows, tasks, executions. Can launch executions. Pretty basic.

Flyte-cli - Python CLI for interacting with admin + data catalog.
Flytectl - Go CLI for interacting with admin + data catalog.

Kubernetes dashboard is used to show logs when using the sandbox.

[Cloudwatch events](https://github.com/flyteorg/flyte/blob/master/helm/values-eks.yaml#L322) are used to run workflows on a schedule.

[Cluster resource manager](https://github.com/flyteorg/flyte/blob/master/helm/values-eks.yaml#L365) for automatic configuration and management of namespaces etc.

## Containers

Each node runs inside a pod. Data management (ie: download/upload of inputs/outputs) is handled either by:

- flytekit
- [raw containers](https://docs.flyte.org/projects/cookbook/en/stable/auto/core/containerization/raw_container.html) (copilot) - inputs/outputs side-loaded at a specific path, see [DataLoadingConfig](https://docs.flyte.org/projects/flyteidl/en/stable/protos/docs/core/core.html?highlight=copilot#dataloadingconfig) and [Flyte copilot](https://docs.google.com/document/d/1ZsCDOZ5ZJBPWzCNc45FhNtYQOxYHz0PAu9lrtDVnUpw/edit#)

[Pod tasks](https://docs.flyte.org/projects/cookbook/en/stable/auto/integrations/kubernetes/pod/pod.html) can run multiple containers for a task.

## Features

- [Caching / Memoization](https://docs.flyte.org/en/stable/howto/enable_and_use_memoization.html)
- [User stats via statsd](https://docs.flyte.org/en/stable/concepts/observability.html#user-stats-with-flyte)
- [Data Catalog](https://docs.flyte.org/en/stable/concepts/catalog.html) indexes parameterized, strongly-typed data artifacts across revisions. It also powers Flyte's memoization system.
- [Authentication](https://docs.flyte.org/en/stable/howto/authentication/index.html)
- [Secrets injection](https://docs.flyte.org/projects/cookbook/en/stable/auto/core/containerization/use_secrets.html)
- [Fast registration](https://docs.flyte.org/en/stable/howto/fast_registration.html) to rerun without rebuilding a container
- [Task logging](https://github.com/flyteorg/flyte/blob/master/helm/values-eks.yaml#L302) to cloudwatch and/or kubernetes logs.
- [Workflow notifications](https://github.com/flyteorg/flyte/blob/master/helm/values-eks.yaml#L344) via SNS

## Install

This will start a k3s cluster in docker and then deploy flyte to it. It requires privileged mode, so dind (docker in docker) can be used to build images.

```
git clone git@github.com:flyteorg/flytesnacks.git
cd flytesnacks

# start ghcr.io/flyteorg/flyte-sandbox:dind
make start
```

You can access flyteconsole on [localhost:30081/console](http://localhost:30081/console). Workflows under _cookbook/_ are registered in the flytesnacks project development domain.

To inspect the k3s cluster:

```
# enter sandbox
docker exec -it flyte-sandbox bash

# watch k3s pods
k3s kubectl get po -A --watch
```

[syncresources](https://github.com/flyteorg/flyte/blob/master/kustomize/base/admindeployment/clustersync/cron.yaml) - a cronjob that runs `flyteadmin --config /etc/flyte/config/*.yaml clusterresource sync` every minute. This [syncs](https://github.com/flyteorg/flyteadmin/blob/2d81c1eec24cffb43346b56fc0017fd29db33a38/cmd/entrypoints/clusterresource.go#L71) cluster resources.

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

Argo has only limited [memoization](https://argoproj.github.io/argo-workflows/memoization/) (only 1MB) stored in a ConfigMap.

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
