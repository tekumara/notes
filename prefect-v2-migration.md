# prefect 2 migration

```python
import prefect
import prefect.context
from prefect import Flow, task, get_run_logger
```

```
rg -F -l 'logger = prefect.context.get("logger")' | xargs sed -i '' 's/logger = prefect.context.get("logger")/logger = get_run_logger\(\)/g'
```

```
    ctx: prefect.context.TaskRunContext = get_run_context()  # type: ignore
    flowlink = f"https://cloud.prefect.io/flow-run/{ctx.task_run.flow_run_id}"
```
