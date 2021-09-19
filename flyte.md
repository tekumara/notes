# flyte

Flyte is a a strongly typed framework for authoring tasks and workflows, and executing them in a Kubernetes cluster. It is positioned for both Data and ML workflows and can integration with Spark, AWS Batch, SageMaker, Kubeflow and more.

The gRPC for data workloads: Flyte's unique aspect is its [type system](https://docs.flyte.org/projects/cookbook/en/latest/auto/core/type_system/index.html) which strongly types inputs and outputs to tasks and marshalls them between tasks via S3 storage. The storage format depends on the type and may be protobuf (primitive types), raw files (Blob type), or parquet (FlyteSchema). This type system powers features like lineage and caching.

## Features

- Multi-tenancy enabled via [projects and domains](https://docs.flyte.org/en/latest/concepts/control_plane.html#control-plane).
- [Multi-cluster](https://docs.flyte.org/projects/cookbook/en/latest/auto/deployment/multiple_k8s.html) support for extreme scale.
- [Caching / Memoization](https://docs.flyte.org/projects/cookbook/en/latest/auto/core/flyte_basics/task_cache.html) of tasks based on inputs, signature and version. Cached outputs are stored in S3.
- [User stats via statsd](https://docs.flyte.org/en/stable/concepts/observability.html#user-stats-with-flyte)
- [System stats](https://docs.flyte.org/en/latest/deployment/cluster_config/monitoring.html) via prometheus endpoint + grafana dashboards
- [Authentication](https://docs.flyte.org/en/stable/howto/authentication/index.html) - OIDC
- [Secrets injection](https://docs.flyte.org/projects/cookbook/en/stable/auto/core/containerization/use_secrets.html)
- [Fast registration](https://docs.flyte.org/projects/cookbook/en/latest/auto/deployment/fast_registration.html) can launch a task < 1 minute, by rerunning the task without rebuilding the container.
- [Task logging](https://github.com/flyteorg/flyte/blob/master/helm/values-eks.yaml#L302) to cloudwatch and/or kubernetes logs.
- [Workflow notifications](https://docs.flyte.org/en/latest/deployment/cluster_config/notifications.html) via email, Pagerduty, Slack
- Workflows can be triggered via an API call
- [Scheduled workflows](https://docs.flyte.org/projects/cookbook/en/latest/auto/deployment/lp_schedules.html) via CloudWatch Events
- [Type system](https://docs.flyte.org/projects/cookbook/en/latest/auto/core/type_system/index.html) ensures inputs and outputs to tasks are strong typed and tracked.
- [Data Catalog](https://docs.flyte.org/en/stable/concepts/catalog.html) indexes parameterized, strongly-typed data artifacts across revisions. It also powers Flyte's memoization system.
- [Extensible](https://docs.flyte.org/projects/cookbook/en/latest/auto/core/extend_flyte/index.html) - plugins can be written to call other services (with concurrency controlled via a [resource manager](https://github.com/flyteorg/flyteplugins/blob/master/go/tasks/pluginmachinery/core/resource_manager.go#L38))
- Composable - tasks can be easily reused and composed across many workflows. This makes it easy for downstream tasks to be triggered by upstream tasks (even when tasks are owned by different teams).

### vs argo

Argo pushes inputs and outputs via stdin/stdout vs Flyte stores them in S3 and metadata in the Data Catalog.

Argo was YAML first, although there is now a [Python DSL for Argo](https://github.com/argoproj-labs/argo-python-dsl). See also [couler](https://github.com/couler-proj/couler).

Argo doesn't have types, and is basically stringly-typed.

Argo has only limited [memoization](https://argoproj.github.io/argo-workflows/memoization/) (only 1MB) stored in a ConfigMap.

Storing Argo DAG history only a recent feature.

### vs airflow

Flyte supports ETL workloads and was Lyft's response to Airflow limitations including:

- multi-tenancy (ie: different workloads can run in different namespaces, rather than having ML and ETL jobs share scheduler resources)
- multi-cluster eg: single flyteadmin, multi-flytepropeller
- multi-repo / multi-container
- enhanced interactivity (UI and APIs for triggering)
- DAG versioning (ie: multiple versions of the same DAG can run with different inputs and on different schedules)
- Task caching as a first-class feature

### vs kubeflow pipelines

caches artifacts
doesn't require cluster admin

## Concepts

- [Task](https://docs.flyte.org/en/stable/concepts/tasks.html#divedeep-tasks) - an independent unit of processing, with or without side-effects.
- [Workflow](https://docs.flyte.org/en/stable/concepts/workflows_nodes.html) - a graph of nodes. Defined in protobuf. Workflows can refer to tasks or workflows outside their own project or domain.
- [Nodes](https://docs.flyte.org/en/stable/concepts/workflows_nodes.html) - a node can be a task, another workflow, or a branch node.
- [Launch plans](https://docs.flyte.org/en/stable/concepts/launchplans_schedules.html) are used to execution a workflow. Can specify bound inputs and a [schedule](https://docs.flyte.org/en/stable/concepts/launchplans_schedules.html#schedules). There can be multiple versions of a launch plan, but only one active launch plan and its schedule. Inactive launch plans can still be triggered manually.
- [Projects](https://docs.flyte.org/en/stable/concepts/projects.htm) - a grouping of tasks and workflows. Resources limits can be set per project.
- [Domains](https://docs.flyte.org/en/stable/concepts/domains.html) - used to denote different deployment environments, eg: staging, production.
- [Plugins](https://docs.flyte.org/en/stable/concepts/architecture.html#data-plane) - a plugin handles a type of task, eg: Hive, Spark, AWS Batch etc.

## Architecture

Protobuf is used to describe all objects in Flyte, including the inputs and outputs of tasks.

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

[Execution queues](https://docs.flyte.org/en/latest/deployment/cluster_config/general.html) hold dynamic and map tasks for execution.

## Containers

Each node runs inside a pod. Data management (ie: download/upload of inputs/outputs) is handled either by:

- flytekit
- [raw containers](https://docs.flyte.org/projects/cookbook/en/stable/auto/core/containerization/raw_container.html) (copilot) - inputs/outputs side-loaded at a specific path, see [DataLoadingConfig](https://docs.flyte.org/projects/flyteidl/en/stable/protos/docs/core/core.html?highlight=copilot#dataloadingconfig) and [Flyte copilot](https://docs.google.com/document/d/1ZsCDOZ5ZJBPWzCNc45FhNtYQOxYHz0PAu9lrtDVnUpw/edit#)

[Pod tasks](https://docs.flyte.org/projects/cookbook/en/stable/auto/integrations/kubernetes/pod/pod.html) can run multiple containers for a task.

## Integrations

- [Spark on kubernetes](https://docs.flyte.org/projects/cookbook/en/stable/auto/integrations/kubernetes/k8s_spark/index.html)

See [Integrations](https://docs.flyte.org/projects/cookbook/en/stable/integrations.html)
