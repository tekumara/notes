# ray

"Kubernetes in Python" or "Multi-processing on a cluster"

- auto-scaling from zero based on task queue depth ([unlike AWS Batch](https://raysummit.anyscale.com/content/Videos/nAcQJ2jkNGDjJ5smP)).
- heterogeneous pipelines across CPU and GPU to maximise GPU usage
- an actor model for stateful computation
- [service discovery/binding](https://docs.ray.io/en/latest/serve/key-concepts.html#servehandle-composing-deployments)
- [gpu sharing](https://docs.ray.io/en/latest/serve/scaling-and-resource-allocation.html#fractional-cpus-and-fractional-gpus)
- process management ie: restarting processes that have died
- [memory monitoring](https://docs.ray.io/en/latest/ray-core/scheduling/ray-oom-prevention.html) and pre-emptive killing of tasks/actors when memory > 95% usage to avoid SIGKILLs from the Linux OOM.
- used of shared memory via /dev/shm for processes on the same host

## ray locally

```
pip install 'ray[default]'
ray start --head
```

Visit dashboard on [http://localhost:8265](http://localhost:8265)

## ray logs

See the `ray_client_server_*` files

`raylet.out` contains stats on the plasma memory usage and out-of-disk errors.
`raylet.err` will have warnings.

## anti-patterns

- [Passing the same large argument by value repeatedly harms performance](https://docs.ray.io/en/master/ray-core/patterns/pass-large-arg-by-value.html)

## spilling

ray spills to _/tmp/ray/session\_\*/ray_spilled_objects_

## vs dask

- core is C++, dask is pure python
- [grpc](https://medium.com/riselab/optimizing-distributed-futures-over-grpc-f34c01b7905c) used for rpc
- a [distributed scheduler](https://www.youtube.com/watch?v=2fem9_iBo-c) vs the central dask scheduler - see [Ownership](https://docs.google.com/document/d/1tBw9A4j62ruI5omIJbMxly-la5w4q_TjyJgJL_jN2fI/preview#heading=h.vjc9egi2q5aa)
- workers on the same node can share memory via the [plasma object store](https://docs.ray.io/en/latest/ray-core/objects/serialization.html), which allows zero-copy read-only access to numpy arrays
- [spill to s3](https://docs.ray.io/en/latest/ray-core/objects/object-spilling.html)

## ray serve

adds http + routing + queuing + [request batching](https://docs.ray.io/en/latest/serve/advanced-guides/dyn-req-batch.html)

## ray jobs

The ray job entrypoint script runs on the head node.
`ray.init` inside the script connects to the head node's cluster. Any remote tasks run on the cluster.

The alternative is to run the script from a client. Using a job avoids requiring a long-running connection to the cluster.

## remote debugging

You can use VS Code breakpoints in remote tasks/actors and attach to the head/driver, but you won't be able to see the local variables in a local subprocess or a remote process on a cluster.

To debug a sub/remote process you'll need to get it to trigger the debugger:

1. First install `debugpy` into your ray environment before starting ray.
1. Then add a `breakpoint()` line to your remote code. When this is hit, the program will pause and you'll see the debugger listening on a randomly assigned port:

   > Ray debugger is listening on 127.0.0.1:60895

You can create a launch config with this port and connect, or you can use the [Ray Distributed Debugger VS Code plugin](https://marketplace.visualstudio.com/items/?itemName=anyscalecompute.ray-distributed-debugger).

The plugin finds the remote task via the dashboard and attaches to it. For the task to be visible to the plugin, ray must be started with the dashboard, which is installed via `pip install "ray[default]"`. When ray starts the dashboard you'll see the following in the logs:

> ... View the dashboard at http://127.0.0.1:8265

See [Ray Distributed Debugger](https://docs.ray.io/en/latest/ray-observability/ray-distributed-debugger.html).

NB: the `RAY_DEBUG` env var doesn't need to be set.

## troubleshooting

## job submit but nothing happens

Make sure you don't have a local ray running and it's gone there instead.

### ray.exceptions.OwnerDiedError

Usually an [OOM](https://docs.ray.io/en/latest/ray-core/scheduling/ray-oom-prevention.html). Consider:

- reducing total memory usage of actors
- release object refs earlier, eg: don't return all object refs to the driver but block and consume them in tasks instead. This applies back pressure.
- [explicitly reduce task concurrency](https://docs.ray.io/en/latest/ray-core/patterns/limit-running-tasks.html#core-patterns-limit-running-tasks)

see also [Debugging Memory Issues](https://docs.ray.io/en/latest/ray-observability/user-guides/debug-apps/debug-memory.html) or use `ray memory` to [inspect ray's object store](https://docs.ray.io/en/latest/ray-core/scheduling/memory-management.html#debugging-using-ray-memory).

eg:

> 2023-05-27 13:36:07,868 WARNING worker.py:2519 -- Local object store memory usage:
>
> ...
>
> ray.exceptions.OwnerDiedError: Failed to retrieve object a5300f64f1f49e3e4b0059ea50255f4bb54c8fa60100000001000000. To see information about where this ObjectRef was created in Python, set the environment variable RAY_record_ref_creation_sites=1 during `ray start` and `ray.init()`.
>
> The object's owner has exited. This is the Python worker that first created the ObjectRef via `.remote()` or `ray.put()`. Check cluster logs (`/tmp/ray/session_latest/logs/*1c42378b72acbfbbddde06a70a3fc7c0a50d6870069bcc339a0f1ff1*` at IP address 10.97.37.135) for more information about the Python worker failure.

Check the gcs logs, to see more details about the exit:

```
rg -C5 exit /tmp/ray/session_latest/logs/gcs_server.out

...
2734-Execution time:  mean = 64.696 us, total = 189.431 ms
2735-Event stats:
2736-   TaskInfoGcsService.grpc_server.AddTaskEventData - 2928 total (0 active), CPU time: mean = 64.696 us, total = 189.431 ms
2737-
2738-
2739:[2023-05-27 13:36:07,742 W 114781 114781] (gcs_server) gcs_worker_manager.cc:55: Reporting worker exit, worker id = 1c42378b72acbfbbddde06a70a3fc7c0a50d6870069bcc339a0f1ff1, node id = ffffffffffffffffffffffffffffffffffffffffffffffffffffffff, address = , exit_type = NODE_OUT_OF_MEMORY, exit_detail = Task was killed due to the node running low on memory.
2740:Memory on the node (IP: 10.97.37.135, ID: 50eef2b904b8560b750470569043954872b03131ec93d5a67a7c91e9) where the task (task ID: NIL_ID, name=download_batch, pid=115205, memory used=0.18GB) was running was 14.67GB / 15.44GB (0.95015), which exceeds the memory usage threshold of 0.95. Ray killed this worker (ID: 1c42378b72acbfbbddde06a70a3fc7c0a50d6870069bcc339a0f1ff1) because it was the most recently scheduled task; to see more information about memory usage on this node, use `ray logs raylet.out -ip 10.97.37.135`. To see the logs of the worker, use `ray logs worker-1c42378b72acbfbbddde06a70a3fc7c0a50d6870069bcc339a0f1ff1*out -ip 10.97.37.135. Top 10 memory users:
...

```

For more detail:

```
rg -C5 'killed|died|exit' /tmp/ray/session_latest/logs
```

### File system monitor

Indicates disk is over 95% full:

```
 file_system_monitor.cc:116: /tmp/ray/session_2025-05-27_08-49-02_002069_48979 is over 95% full, available space: 21.5741 GB; capacity: 460.432 GB. Object creation will fail if spilling is required.
```

## Rolling updates

Not supported - requires multiple ray clusters see [#527](https://github.com/ray-project/kuberay/issues/527#issuecomment-1920616895)

## Deployment Best Practices on Ray

- 1 job at a time on a Ray cluster. Ray currently does not have physical resource isolation between jobs nor multi-tenancy support (fairness, sharing between independent jobs). Consider implementing a job queue or multiple clusters. See [Do Ray clusters support multi-tenancy?](https://docs.ray.io/en/latest/cluster/faq.html#do-ray-clusters-support-multi-tenancy)

- Avoid using Ray Client. Ray Client has architectural limitations, is not actively maintained and can lead to compatibility issues with Ray libraries. The best practice is to run jobs directly on the head node of the cluster using `ray.init()`.

Source: [Best Practices for Ray in Production](https://www.youtube.com/watch?v=FXfQ1eI89Kk)
