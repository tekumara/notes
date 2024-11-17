# dask

## Usage

Connect to existing cluster:

```python
from dask.distributed import Client
client = Client('dask-root-8ad03e68-6:8786')
```

## Rerun tasks

Dask may [run tasks multiple times](https://distributed.dask.org/en/stable/limitations.html#assumptions-on-functions-and-data). This will occur when the worker running the task dies, or when a worker holding an [intermediate results dies](https://distributed.dask.org/en/latest/memory.html#resilience) and so the intermediate result needs to be recalculated. This can happen as part of normal operation, particularly when using adaptive scaling. When a worker dies you'll see this in the logs to indicate the task is being rerun:

> Couldn't gather 736 keys, rescheduling

Dask's design works well for pure computation, but requires tasks with side-effects (eg: a task writing results to storage) to be idempotent. See [this reproduction](https://github.com/dask/distributed/issues/2935) of the behaviour. This is less-likely to happen if the side-effect is the terminal task, as it won't have any intermediate results that require recomputing. But it could still be retried if the worker dies part way through the task.

If a task repeatedly kills its worker, eventually Dask will throw a [KilledWorker exception](https://distributed.dask.org/en/stable/killed.html).

See also [Managing Memory](https://distributed.dask.org/en/stable/memory.html):

> The result of a task is kept in memory if either of the following conditions hold:
> A client holds a future pointing to this task. The data should stay in RAM so that the client can gather the data on demand.
> The task is necessary for ongoing computations that are working to produce the final results pointed to by futures. These tasks will be removed once no ongoing tasks require them.
>
> ...
>
> The complete graph for any desired Future is maintained until no references to that future exist.

## Dashboard

[Task stream](https://docs.dask.org/en/stable/dashboard.html#task-stream) - To zoom click the wheel zoom icon then move the mouse wheel. The wheel zoom icon has a button and magnifying glass and is the third icon from the left.

## Dumps

Take a cluster dump:

```python
client.dump_cluster_state("s3://my-bucket/dask-root-8ad03e68-6.dump")
```

During a dump you'll see `Event loop was unresponsive` info log messages on the scheduler and active workers.

Analyse using [DumpArtefact](https://github.com/dask/distributed/blob/main/distributed/cluster_dump.py):

```python
from distributed.cluster_dump import DumpArtefact
url = "file:///Users/tekumara/Downloads/dask-root-8ad03e68-6.dump.msgpack.gz"
dump = DumpArtefact.from_url(url)
```

## Deadlock

Run [this check-deadlock.py](https://github.com/dask/distributed/issues/5879#issuecomment-1054873941).

During the script you'll see `Run out-of-band function 'lambda'`
