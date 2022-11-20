# prefect dask

## Rerun tasks

Dask may [run tasks multiple times](dask.md#rerun-tasks).

Even though in Prefect a task may have max_retires = 0, this still occurs because of how Dask is designed. Instead, Prefect offers caching and version locking to mitigate this, see [#5485](https://github.com/PrefectHQ/prefect/issues/5485#issuecomment-1107100864).
