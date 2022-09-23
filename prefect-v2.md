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

Tasks cannot be run within tasks, but normal functions can. This forces the execution graph into a flow.

## Memory consumption

Prefect 2 does not release memory eagerly for tasks that are submitted as futures, because Prefect can't know if the result will be needed downstream. Prefect might also hold onto the data for normal task calls too as it tracks the state of all task runs created in a flow.

Upcoming work on result handling will optimize memory handling.

If no result is returned from a subflow, Prefect defaults to a state that bundles all the task states from within the subflow. By returned a value it'll release all tasks on completion.

## Troubleshooting

### Crash detected! Execution was interrupted by an unexpected exception.

The pod failed before prefect could start. Check the pod logs.

### Late runs

- Check the logs of the agent.
- Check the agent is configured with the correct PREFECT_API_URL / PREFECT**CLOUD**API env var.
