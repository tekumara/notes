# python input

## CTRL+C / SIGINT / KeyboardInterruption

Signals are sent to the main thread only. CTRL+C generates the SIGINT signal. The default signal handler (`signal.int_signal_handler`) raises `KeyboardInterrupt`. This will raise on the main thread only. If you are currently blocking on another thread, it won't propagate, eg: if `input` is running on a separate thread it doesn't receive the exception. So you'll need to press Enter (or another CTRL+C) to unblock first.

Use prompt_toolkit instead for asyncio and readline support. SIGINTs will be raised on the main thread, stopping the event loop.
[aioconsole](https://github.com/vxgmichel/aioconsole/tree/main) works too but doesn't have readline support.

[aiorun](https://github.com/cjrh/aiorun) will [catch KeyboardInterrupt](https://github.com/cjrh/aiorun/blob/fd1702346bc2881c6895a0d2dfc3a37660b09421/aiorun/__init__.py#L258) stop the loop, print "Stopping the loop", and cancel any tasks.
