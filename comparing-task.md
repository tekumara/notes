# comparing task in different workflow engines

A unit of execution. The semantics differ be workflow engine.

[Flyte](https://docs.flyte.org/en/latest/concepts/tasks.html)

- a task is a workload, most of which run as a Kubernetes Pod, but also includes integrations like Spark, AWS Batch, SageMaker
- a task has typed inputs and outputs, which are [loaded](https://github.com/flyteorg/flyteidl/blob/master/protos/flyteidl/core/tasks.proto#L215) to/from the running container and S3
- a task can be executed independently
- a task can be executed as part of a workflow when triggered by an upstream task
- launching a task requires specifying its inputs
- retries, timeouts, and memorization

[Airflow](https://airflow.apache.org/docs/apache-airflow/stable/concepts/tasks.html)

- a task is a Python object for building DAGs
- retries, timeouts, and SLAs

[Prefect](https://docs.prefect.io/core/concepts/tasks)

- a unit of execution described in Python
- can be run by different [Executors](https://docs.prefect.io/core/concepts/engine.html#executors) ie: in-process, threaded/multiprocess, distributed
- prefect eliminates negative engineering by abstracting common needs into the framework
- retries, timeouts, and caching
- an optional result which can be [persisted using cloudpickle](https://docs.prefect.io/core/concepts/results.html#pipeline-persisted-results) when checkpointing is enabled
