# python async

## Start an event loop

If `main` is async:

```
asyncio.run(main())
```

Start an async repl:

```
$ python -m asyncio
asyncio REPL 3.9.7 (default, Nov 17 2021, 17:03:31)
[Clang 12.0.5 (clang-1205.0.22.9)] on darwin
Use "await" directly instead of "asyncio.run()".
Type "help", "copyright", "credits" or "license" for more information.
>>> import asyncio
>>>
```

## Tasks

Use a task when you wait your coroutine to run in the background. `asyncio.create_task` will execute the task on the event loop and return a `Task` which is subclass of `Future`. A task can be awaited.

Save a reference to task returned from `asyncio.create_task`, to avoid it being [garbage-collected mid-execution](https://docs.astral.sh/ruff/rules/asyncio-dangling-task/).

### Task Groups

If work1 or work2 throws an exception, the other task will keep running.

```python
    t1 = asyncio.create_task(work1())
    t2 = asyncio.create_task(work2())
    await asyncio.wait([t1, t2])
```

If the exception is unretrieved, its trackback won't appear until exit where it will be displayed with the message `Task exception was never retrieved`.

To have the exception cancel the other running task, use a TaskGroup:

```python
    async with asyncio.TaskGroup() as tg:
        t1 = asyncio.create_task(work1())
        t2 = asyncio.create_task(work2())
```

The TaskGroup will wait for both tasks to complete, and will cancel one if the other throws an exception. The exception will retrieve and propagate the exception as an ExceptionGroup.

## Notes

An object constructor cannot be async.
