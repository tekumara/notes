# prefect v1 usage

Features:

- retries and failure handling
- scheduling
- a state machine for recording tasks [states](https://docs-v1.prefect.io/core/concepts/states.html)
- state handling for state transitions of [tasks](https://discourse.prefect.io/t/how-to-take-action-on-a-state-change-of-a-task-run-task-level-state-handler/82) and [flows](https://docs-v1.prefect.io/core/concepts/flows.html#state-handlers)
- error reporting and visibility into task run states
- error handling by triggering tasks from Failed states
- concurrent execution defined by a DAG (aka Flow) across multiple functions
- task and flow level concurrency limits
- [caching](https://docs-v1.prefect.io/core/concepts/persistence.html#input-caching) of task outputs and inputs

## Authentication

`prefect auth login` creates _~/.prefect/auth.toml_ and stores the API key there.

What I recommend doing though is using the environment variable `PREFECT__CLOUD__API_KEY`. Prefect will use this if it is set, rather than _auth.toml_.It avoids storing the key on disk and is more secure.

## Task inputs and outputs in the UI

Prefect tracks the values of Parameters to flows, but not the values of task inputs in the UI. So these aren't monitored out of the box.

As a workaround, [name your task runs](https://docs-v1.prefect.io/core/idioms/task-run-names.html#naming-task-runs-based-on-inputs) based on inputs.

Outputs can be persisted and shown in the UI using [PrefectResult()](https://docs-v1.prefect.io/core/advanced_tutorials/using-results.html#running-a-flow-with-prefectresult).

## Logs

Logs must be explicitly sent to Prefect. But many libraries will write to stdout directly. To [log stdout to Prefect](https://docs-v1.prefect.io/core/concepts/logging.html#logging-stdout):

```python
@task(log_stdout=True)
```

## UI

The project and tenant dashboard views will show an aggregated view of flow runs. Flow runs may be hidden in the Run History chart view if they occur at the same time. Navigate to the individual flow first.

The UI is slow and crashes at times.

## Troubleshooting

### Found no flows

Flow objects must exist in the module namespace to be found. Flows that only have function-local references will not be found.
