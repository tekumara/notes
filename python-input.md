# python input

## CTRL+C / SIGINT / KeyboardInterruption

Signals are sent to the main thread only. CTRL+C generates the SIGINT signal. The default signal handler (`signal.int_signal_handler`) raises `KeyboardInterrupt`. This will raise on the main thread only. If you are currently blocking on another thread, it won't propagate, eg: if `input` is running on a separate thread it doesn't receive the exception. So you'll need to press Enter (or another CTRL+C) to unblock first.

Use prompt_toolkit instead for asyncio and readline support. SIGINTs will be raised on the main thread, stopping the event loop. [aioconsole](https://github.com/vxgmichel/aioconsole/tree/main) works too but doesn't have readline support.

### Asyncio SIGINT handling

If you run the low-level functions yourself, eg:

```python
    loop = asyncio.get_event_loop()
    result = loop.run_until_complete(do_work())
```

then SIGINT will abort the loop and not give tasks any way to cleanup.

[asyncio.run()](https://github.com/python/cpython/blob/b5fafc3ab9e970be07fb3a69a9025aea7b26d0d6/Lib/asyncio/runners.py) installs a SIGINT handler that propagates a asyncio cancellation, for more background info see [Handling Keyboard Interruption](https://docs.python.org/3/library/asyncio-runner.html#handling-keyboard-interruption).

[aiorun](https://github.com/cjrh/aiorun) is similar to asyncio.run - ie: [catch KeyboardInterrupt](https://github.com/cjrh/aiorun/blob/fd1702346bc2881c6895a0d2dfc3a37660b09421/aiorun/__init__.py#L258) stop the loop, print "Stopping the loop", and cancel any tasks. Difference are:

- runs forever
- has [a `shutdown_waits_for` feature](https://github.com/cjrh/aiorun?tab=readme-ov-file#id6)
