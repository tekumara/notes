# prefect

## Philosophy

Prefect should be invisible. It adds workflow semantics to python functions by converting them into tasks which provides:

- retries and failure handling
- scheduling
- a state machine for recording tasks [states](https://docs.prefect.io/concepts/states/) and the [final flow state](https://docs.prefect.io/concepts/states/#final-state-determination)
- error reporting and visibility into task run states
- error handling by triggering tasks from Failed states
- concurrent execution defined by a DAG (aka Flow) across multiple functions
- task and flow level concurrency limits
- [caching](https://docs.prefect.io/core/concepts/persistence.html#input-caching) of task outputs and inputs

## Memory consumption

Prefect 2 does not release memory eagerly for tasks that are submitted as futures, because Prefect can't know if the result will be needed downstream. Prefect might also hold onto the data for normal task calls too as it tracks the state of all task runs created in a flow.

Upcoming work on result handling will optimize memory handling.

If no result is returned from a subflow, Prefect defaults to a state that bundles all the task states from within the subflow. By returned a value it'll release all tasks on completion.

## Types of submission

Start concurrently in flow runner, return result:

```python
    r1 = t1()
    r2 = t2()
```

Start concurrently on task runner, return future

```python
    f1 = t1.submit()
    f2 = t2.submit()
```

Start sequentially on task runner, wait until terminal state reached, and return state

```python
    s1 = t1.submit().wait() # Completed/Failed
    s2 = t2.submit().wait() # Completed/Failed

    # equivalent to
    s1 = t1.submit(return_state=True)   # Completed/Failed
    s2 = t2.submit(return_state=True)   # Completed/Failed
```

Start sequentially on task runner, and return state without waiting

```python
    s1 = t1.submit().get_state() # Pending/Running
    s2 = t2.submit().get_state() # Pending/Running
```

Start sequentially on task runner, wait until terminal state reached, and return result

```python
    r1 = t1.submit().wait().result()
    r2 = t2.submit().wait().result()

    # equivalent to
    s1 = t1.submit().result()
    s2 = t2.submit().result()
```

To return an exception result rather than raising it:

```python
    s1 = t1.submit().result(raise_on_failure=True)
```

Mapping always runs concurrently via the task runner:

```python
   futures = add_one.map([1, 2, 3])  # returns List[PrefectFuture]
   futures = add_one.map([1, 2, 3], return_state=True)  # waits on each future to reach a terminal state and returns List[State]
```

See [States](https://docs.prefect.io/concepts/states/)

## Logging

Prefect will override any explicit logging config, eg: (`logging.basicConfig()`) and config logging according to its [logging.yml](https://github.com/PrefectHQ/prefect/blob/c4b74cfd3b3b693fc228261abee00a8b3bef6f43/src/prefect/logging/logging.yml). This defaults to INFO level logs from prefect's own logger, and [WARNING level logs](https://github.com/PrefectHQ/prefect/blob/c4b74cfd3b3b693fc228261abee00a8b3bef6f43/src/prefect/logging/logging.yml#L123) for everything else.

To capture non-Prefect loggers and send them to Prefect via the [API handler](https://github.com/PrefectHQ/prefect/blob/c4b74cfd3b3b693fc228261abee00a8b3bef6f43/src/prefect/logging/logging.yml#L82) (but not the console):

```
PREFECT_LOGGING_EXTRA_LOGGERS=httpx python -m myflow
```

Non-Prefect loggers use the [`prefect.extra` handler](https://github.com/PrefectHQ/prefect/blob/c4b74cfd3b3b693fc228261abee00a8b3bef6f43/src/prefect/logging/configuration.py#L94). To send their logs to the console as well as the API set:

```
PREFECT_LOGGING_LOGGERS_PREFECT_EXTRA_PROPAGATE=true
```

Structlog loggers will bypass Prefect logging altogether.

## Gotchas

This is supposed to override the root log level:

```
PREFECT_LOGGING_ROOT_LEVEL=info python -m myflow
```

However, it silences all logs ... unless you reset logging:

```
logging.basicConfig(level=logging.INFO, force=True)
```





To override level for a third party logger (defaults to warning):

```
PREFECT_LOGGING_LOGGERS_HTTPX_LEVEL=info
```

## Troubleshooting

### Crash detected! Execution was interrupted by an unexpected exception.

The pod failed before prefect could start. Check the pod logs.

### Late runs

- Check the logs of the agent.
- Check the agent is configured with the correct PREFECT_API_URL / PREFECT**CLOUD**API env var.

```

```
