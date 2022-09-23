# dask

## Rerun tasks

Dask may [run tasks multiple times](https://distributed.dask.org/en/stable/limitations.html#assumptions-on-functions-and-data). This will occur when the worker running the task dies, or when a worker holding an [intermediate results dies](https://distributed.dask.org/en/latest/memory.html#resilience) and so the intermediate result needs to be recalculated. This can happen as part of normal operation, particularly when using adaptive scaling. Dask's design works well for pure computation, but requires tasks with side-effects (eg: a task writing results to storage) to be idempotent. See [this reproduction](https://github.com/dask/distributed/issues/2935) of the behaviour. This is less-likely to happen if the side-effect is the terminal task, as it won't have any intermediate results that require recomputing. But it could still be retried if the worker dies part way through the task.

If a task repeatedly kills its worker, eventually Dask will throw a [KilledWorker exception](https://distributed.dask.org/en/stable/killed.html).
