# dagster

A set of abstractions for pipelines that enables the definition and separation of computation, I/O, resources, schedules, assets and more.

## Main Concepts

- [Solids](https://docs.dagster.io/concepts/solids-pipelines/solids) define computation. Solids are testable, and have gradual typing of inputs and outputs.
- [Pipelines](https://docs.dagster.io/concepts/solids-pipelines/pipelines) a DAG of solids.
- Solids can emit [events and exception](https://docs.dagster.io/concepts/solids-pipelines/solid-events) that indicate an output, exception, assert materialisation etc. This can be viewed in the UI (Dagit).
- [IO Managers](https://docs.dagster.io/concepts/io-management/io-managers) store solid outputs and load solid inputs from a data store, eg: S3
- [Resources](https://docs.dagster.io/concepts/modes-resources) are externals dependencies like a database or API that are used in a solid. They can represent different execution environments, eg: in-memory during testing, a staging database, and a production database
- [Assets](https://docs.dagster.io/concepts/assets/asset-materializations) are external entities that are created or mutated by a solid, eg: a table, ML model, slack channel. The [Dagit Asset Catalog](https://docs.dagster.io/concepts/dagit/dagit#assets) can track interactions with an asset over time.
- [Config schema](https://docs.dagster.io/concepts/configuration/config-schema) allows parameters to be provided at run time for pipelines
- [Repositories](https://docs.dagster.io/concepts/repositories-workspaces/repositories) a collection of pipelines, schedules, sensors and partition sets. Each repository can have a [custom python environment](https://docs.dagster.io/concepts/repositories-workspaces/workspaces#multiple-python-environments).
- [Workspaces](https://docs.dagster.io/concepts/repositories-workspaces/workspaces) a collection of repositories.
- [Partitions](https://docs.dagster.io/concepts/partitions-schedules-sensors/partitions) for runs that deal with data subsets (eg: by time)
- [Schedules](https://docs.dagster.io/concepts/partitions-schedules-sensors/schedules) including [partition-based schedules](https://docs.dagster.io/concepts/partitions-schedules-sensors/schedules#partition-based-schedules),
- [Sensors](https://docs.dagster.io/concepts/partitions-schedules-sensors/sensors) that trigger runs on external state change, eg: a file landing in an s3 bucket

## Features

- [Backfills](https://docs.dagster.io/concepts/partitions-schedules-sensors/backfills) of partitions
- [Gradual typing of inputs and outputs](https://docs.dagster.io/concepts/types)
- [Testability](https://docs.dagster.io/concepts/testing)
- [Dynamic Dags](https://github.com/dagster-io/dagster/issues/462)
- [Versioning and memoization/caching (Experimental)](https://docs.dagster.io/guides/dagster/memoization)
- [k8s requests/limits](https://github.com/dagster-io/dagster/issues/3483#issuecomment-754305435)
- launch remote processes, eg: [AWS batch](<(https://dagster.slack.com/archives/CCCR6P2UR/p1614041404042600)>)) or a specialised step launcher eg: the [EMR PySpark step launcher](https://docs.dagster.io/integrations/pyspark#submitting-pyspark-solids-on-emr)
- [Software-defined assets](https://dagster.io/blog/software-defined-assets) aka "Reconciliation-based orchestration", ie: scheduling based on the presence of input data and the absence of output data. The scheduler is aware of the (possibly time-partitioned) inputs and outputs of each workflow and then it continually schedules a set of workflows as each workflow's input becomes available.

Not supported

- [Service accounts per run](https://github.com/dagster-io/dagster/issues/3445)

## Deployments and execution frameworks

Dagster running on [Kubernetes](https://docs.dagster.io/deployment/guides/kubernetes/deploying-with-helm) using the [K8sRunLauncher](https://docs.dagster.io/_apidocs/libraries/dagster-k8s#dagster_k8s.K8sRunLauncher) which creates a Kubernetes Job or CronJob per pipeline run using the image specified in the [User Code Deployment](https://docs.dagster.io/deployment/guides/kubernetes/deploying-with-helm#user-code-deployment). These images contain a dagster repository. Jobs and pods are not automatically deleted so users can inspect results.

Alternatively the [CeleryK8sRunLauncher](https://docs.dagster.io/deployment/guides/kubernetes/deploying-with-helm-advanced#celery) can be used to provide step level isolation and to limit the number of concurrent connections to a resource. The [Run Worker](https://docs.dagster.io/deployment/guides/kubernetes/deploying-with-helm-advanced#run-worker) submits steps to the celery queue. The Celery workers poll for tasks and tasks launch a Kubernetes Job to execute the step.

Dagster can also run pipelines on [dask](https://docs.dagster.io/deployment/guides/dask) and [airflow](https://docs.dagster.io/deployment/guides/airflow)

## Integrations

[Integrations](https://docs.dagster.io/integrations) include:

- Spark
- Papermill

## Dagit (UI)

Visual subsets of a DAG, eg: to display all the predecessor solids of a particular solid foo, just type “\*foo” in the bottom selector."
