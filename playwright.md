# playwright

Tracing:

```python

        context = browser.new_context(storage_state=storage_state)
        context.tracing.start(screenshots=True, snapshots=True, sources=True)

        ...

        context.tracing.stop(path = "trace.zip")
        context.close()
```

View trace:

```
playwright show-trace trace.zip
```
