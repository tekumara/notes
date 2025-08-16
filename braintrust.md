# braintrust

## Issues

Live view - span start is registered but to see completed span requires a manual refresh of the page.

Slow eg:

```
Log search query timed out after 59170ms. [objectType=dataset, page=0]
```

When using `@traced` in python and an ExceptionGroup is raised I don't get the traceback for the sub-exceptions. See https://github.com/braintrustdata/braintrust-sdk/issues/787

When I add an otel log to a dataset, then try to jump from the dataset row back to the otel log via the "copied the dataset row from log" link under Activity, I get a Couldn’t find object with ID 448690d8253b07c7. Is this expected?

## Security

SCIM
Write-only api keys
Max-session duration
