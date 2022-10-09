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

## Troubleshooting
