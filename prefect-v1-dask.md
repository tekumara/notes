# prefect v1 dask

##


## Task reruns

When Dask reruns a task (eg: because the worker was killed) Prefect does not capture the logs from the second invocation.
