# fastapi

## Background tasks

Can be async and run on the event loop, or sync and run on the thread pool.

### Gotchas

Background tasks run after returning a response, ie: the `return` statement in an endpoint. If the endpoint throws an exception, the task does not run, see [#2604](https://github.com/tiangolo/fastapi/issues/2604#issuecomment-754572045).

Background tasks don't work with middleware that subclasses `BaseHTTPMiddleware`, see [#919](https://github.com/encode/starlette/issues/919).

In either of these cases, consider using:
- `asyncio.create_task(your_coro)` to run an async task on the event loop
- `await run_in_threadpool(your_func, *args, **kwargs)` to run a sync function on the threadpool
