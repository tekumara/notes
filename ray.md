# ray

Auto-scaling ([unlike AWS Batch](https://raysummit.anyscale.com/content/Videos/nAcQJ2jkNGDjJ5smP)).

Has an actor model for stateful computation.

## ray train

Uses [horovod](https://github.com/ray-project/ray_lightning/blob/main/ray_lightning/examples/ray_horovod_example.py) but no fault tolerance out of the box, ie: if a spot node crashes it will crash the whole training process. It's possible to resume from the last checkpoint but this is manual.

See [this slack discussion](https://ray-distributed.slack.com/archives/CSX7HVB5L/p1659539707149619?thread_ts=1659194840.994399&cid=CSX7HVB5L):

> Got it. so I see there are 4 levels in terms of offering fault tolerance:
> trainer.fit() fails when one of the workers is gone. User has to manually call trainer.fit(resume_from_checkpoint=ckpt) to resume training from last checkpoint (I am using Ray AIR training API as an example but the idea is the same) - the concept of worker group is static
> trainer.fit() does not fail when one of the workers is gone. Under the hood, when one worker dies, the other worker in the ring are also stopped and everything is automatically resumed from last checkpoint. New workers will come up to form a new ring. - the concept of worker group is still static
> When one of the workers dies, the rest workers can continue on with the rest of training - Now the concept of worker group is elastic in the sense of dynamically scale down
> When one of the workers dies, the rest can continue and when a new worker can be incorporated back to the worker group - Now worker group is fully elastic (with discovery mechanism in place)
> It’s much easy to get 1 and 2 right than 3 and 4, especially 4.
> The FT support at level 1 and 2 can be provided at Ray Train layer. If you use Ray with Horovod elastic training, you can probably push to 3 (3 is mostly provided by horovod). But there are still some gotchas (readjusting learning rate, repartition dataset as workers die). See Horovod’s own documentation: https://horovod.readthedocs.io/en/stable/elastic_include.html#practical-considerations-consistent-training
> So I would recommend trying if 1 and 2 can already give what you want, before pushing for elastic training.
> FYI, there is a blog post showcasing horovod on ray from Uber: https://eng.uber.com/horovod-ray/

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

ray spills to /tmp/ray/session\_\*/ray_spilled_objects

## vs dask

- core is C++, dask is pure python
- [grpc](https://medium.com/riselab/optimizing-distributed-futures-over-grpc-f34c01b7905c) used for rpc
- a [distributed scheduler](https://www.youtube.com/watch?v=2fem9_iBo-c) vs the central dask scheduler - see [Ownership](https://docs.google.com/document/d/1tBw9A4j62ruI5omIJbMxly-la5w4q_TjyJgJL_jN2fI/preview#heading=h.vjc9egi2q5aa)
- workers on the same node can share memory via the [plasma object store](https://docs.ray.io/en/latest/ray-core/objects/serialization.html), which allows zero-copy read-only access to numpy arrays
- [spill to s3](https://docs.ray.io/en/latest/ray-core/objects/object-spilling.html)

## troubleshooting

## ray.exceptions.OwnerDiedError

Usually an [OOM](https://docs.ray.io/en/latest/ray-core/scheduling/ray-oom-prevention.html). Consider:

- reducing total memory usage of actors
- release object refs earlier, eg: don't return all object refs to the driver but block and consume them in tasks instead. This applies back pressure.
- [explicitly reduce task concurrency](https://docs.ray.io/en/latest/ray-core/patterns/limit-running-tasks.html#core-patterns-limit-running-tasks)

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
