# prefect storage

When using Module storage the flow needs to exist as a variable in the module.

eg:

```
flow.storage = Module("awesomeness.flow")
```

Requires a `flow` variable in the `awesomeness` module. This won't be the case if the flow is built inside a function, eg: because it uses cli params.
