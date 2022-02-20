# prefect

## Authentication

`prefect auth login` creates _~/.prefect/auth.toml_ and stores the API key there.

What I recommend doing though is using the environment variable `PREFECT__CLOUD__API_KEY`. Prefect will use this if it is set, rather than _auth.toml_.It avoids storing the key on disk and is more secure.

## Task inputs and outputs in the UI

Prefect tracks the values of Parameters to flows, but not the values of task inputs in the UI. So these aren't monitored out of the box.

As a workaround, [name your task runs](https://docs.prefect.io/core/idioms/task-run-names.html#naming-task-runs-based-on-inputs) based on inputs.

Outputs can be persisted and shown in the UI using [PrefectResult()](https://docs.prefect.io/core/advanced_tutorials/using-results.html#running-a-flow-with-prefectresult).

## Troubleshooting

### Found no flows

Flow objects must exist in the module namespace to be found. Flows that only have function-local references will not be found.
