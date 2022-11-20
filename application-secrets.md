# application secrets

- stored in memory - most secure... in a distributed compute environment you need per worker memory (to avoid fetching the secret on every task) or the value needs to be serialised and passed with the task, which is a problem if the framework persists task outputs, like prefect does, (although it has a Secret Tasks with a special [SecretResult](https://github.com/PrefectHQ/prefect/blob/a9270d9/src/prefect/engine/results/secret_result.py) handler which just rerun the task instead of persisting)
- store in env var
- persist to disk - harder to find, but persist beyond application if not running in container
