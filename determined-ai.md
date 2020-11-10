# determined-ai

Determined AI provides cluster management for model training, and offer the following [benefits](https://docs.determined.ai/latest/topic-guides/benefits-of-determined.html):

- a multi-user platform for shared access to scare GPU resources (particularly useful on-prem) using fair-sharing with pre-emption. Pre-empted training tasks checkpoint their state before terminating gracefully.
- elastic scaling in the cloud
- scheduling of notebooks, tensorboards, commands and shells on CPUs and training on GPUs
- [multi-machine distributed training](https://docs.determined.ai/latest/topic-guides/effective-distributed-training.html#effective-distributed-training) built on top of [horovod](https://github.com/horovod/horovod) which uses [NVIDIA/nccl](https://github.com/NVIDIA/nccl) and [facebookincubator/gloo](https://github.com/facebookincubator/gloo)
- state-of-the-art hyperparameter tuning algorithm ([ASHA](https://arxiv.org/abs/1810.05934))
- a high-performance random-access data layer ([yogadl](https://docs.determined.ai/latest/how-to/data-layer.html)) that locally caches data read from cloud storage. Enables transparent data sharding across multiple-machines, and resuming training mid-epoch.
- experiment tracking
- team based - resources and experiment results are shared and accessible to any team member with access

On the roadmap:

- model store
- spot instances on AWS
- RBAC
- better CPU support - currently all the CPUs on a CPU-only agent are treated as a single slot

Enterprise edition:

- Okta integration (SAML, SCIM)
- Support & product development
- More high-end offerings to come

## Network connectivity

`det shell open` uses SSH, so require network level access

Notebook access is HTTP proxied via the master, eg: http://master:8080/proxy/80d46f5d-f41c-4dda-ae5c-9c276f61b8f0/

CLI commands use WebSockets to communicate with the master.

## Local cluster install

Local laptop install using [det-deploy](https://docs.determined.ai/latest/how-to/installation/deploy.html):

```shell
pip install determined-deploy
det-deploy local cluster-up --no-gpu
```

This starts 3 containers:

- postgres
- [determined-agent](https://github.com/determined-ai/determined/tree/master/agent)
- [determined-master](https://github.com/determined-ai/determined/tree/master/master)

They are connected by a docker bridge network.
The master UI is served on http://localhost:8080 with user `admin` or `determined` with no password.

To stop the local install:

```shell
det-deploy local cluster-down
```

The docker agents need to mount `/var/run/docker.sock` so they can start and stop containers.

## Using determined

Install the [cli](https://github.com/determined-ai/determined/tree/master/cli) first:

```shell
pip install determined-cli
```

`det notebook start -c .` Start a notebook on the cluster with contents of current dir
`det notebook start --config environment.image=determinedai/environments:cuda-10.1-pytorch-1.4-tf-2.2-gpu-0.7.0` Start a notebook with the TF 2 container  
`det notebook list -a` Show notebooks created by any user, not just yourself  
`det shell start` Start a shell on the cluster. You will need to explicitly kill it afterwards using `det shell kill`

`det experiment create -f const.yaml .` Create experiment defined in _const.yaml_ with model def in current dir, and follow the first trials logs
`det tensorboard start 1` Start tensorboard on the cluster to inspect experiment 1  
`det experiment` list experiments
`det experiment list-trials 1` list trials for experiment 1
`det e label add 17 foobar` Add the label “foobar” to experiment 17
`det trial logs 1` list logs for trial 1

`det user login admin` authenticate as admin for the next 30 days, or until logged out

## Notebooks

By default notebooks are assigned a single GPU, but can be assigned 0 or more than 1.

## Users

Experiments and notebooks are visible to everyone, regardless of who created them.

The cluster comes pre-configured with a `admin` and `determined` user without any password.

By default the cli will authenticate as user `determined`.

`det user change-password` to change the current users password
`det -u admin user change-password` to run as admin and change their password
`det user whoami` to see who you are
`det -u admin user deactivate determined` to deactivate the default determined user
`det -u admin user create alice` create a user alice
`det user list` list users

See [Topic Guides > Users](https://docs.determined.ai/latest/topic-guides/users.html)

## Determined container images

- docker hub: [determinedai/environments](https://hub.docker.com/r/determinedai/environments/tags)
- github: [determined/environments](https://github.com/determined-ai/environments)

## Configuration

[Master configuration](https://docs.determined.ai/latest/reference/cluster-config.html#master-configuration) options:

`max_idle_agent_period` - time to wait before terminating idle dynamic agents. Defaults to 20m.
`tensorboard_timeout` - idle time before terminating tensorboard tasks. [Defaults to 5m](https://docs.determined.ai/latest/how-to/tensorboard.html#lifecycle-management). If a browser tab to an active TensorBoard is closed, that triggers the idle timeout clock. Note: If you turn off TensorBoard auto-refresh, that too is considered as a connection that has fallen idle, and counts towards the timeout, since there is no traffic transiting the proxy service on the Master.

## Batching and Training Units

Training, validation and checkpointing periods can be expressed in the following [training Units](https://docs.determined.ai/latest/reference/experiment-config.html#experiment-configuration-training-units):

- `records`: a record is a single labelled example
- `batches`: a batch is a group of records. The number of records in a batch is configured by `global_batch_size`.
- `epochs`: an epoch is a single copy of the whole training dataset. The number of records in an epoch is configured by [`records_per_epoch`](https://docs.determined.ai/latest/reference/experiment-config.html#config-records-per-epoch).

Every experiment must specify `global_batch_size`. The batch size per slot is `global_batch_size / slots_per_trial`. It’s recommended to set the global_batch_size to the largest batch size that fits into the memory or a single GPU \* number of slots - see [Effective Distributed Training](https://docs.determined.ai/latest/topic-guides/effective-distributed-training.html).

`scheduling_unit` is the number of batches for a single training workload, and is the smallest unit (step) of training that's recorded in tensorboard. Defaults to 100. You'll see each step recorded in the logs as:

```
[2020-10-26T09:35:54Z] 1b0b96fb [RUNNING] ||  INFO: Running workload <RUN_STEP (100 Batches): (7,7,12)>
[2020-10-26T09:35:56Z] 1b0b96fb [RUNNING] ||  INFO: Workload completed: <RUN_STEP (100 Batches): (7,7,12)> (duration 0:00:01.432026)
```

[Batch metrics](https://docs.determined.ai/latest/how-to/tensorboard.html#determined-batch-metrics) are automatically written to tfevents files at the end of each scheduling unit, eg: categorical_accuracy, loss, val_categorical_accuracy, val_loss

`max_length` how many batches to train
`min_validation_period` how often validation will occur during a trial. By default, validation occurs at the end of a trial.
`min_checkpoint_period` if set, take periodic checkpoints during a trial. By default checkpoints are taken when a trial is suspended, completed, or the searcher takes a decision


For more info see [Experiment Configuration](https://docs.determined.ai/latest/reference/experiment-config.html))

## Trials

: a hyperparameter search may train more than one trial at once, each of which will use its own GPUs.

## Searcher and Resuming

[searcher](https://docs.determined.ai/latest/reference/experiment-config.html#searcher)

You can resume a trial from the UI by clicking _Continue Trial_. Or from an experiment by specifying `source_trial_id`

`metric` - defaults to val_loss

## Logs (AWS)

Determined creates the _/determined/determined-ai_ cloudwatch log groups with two streams:

- determined-master
- determined-agent

## Troubleshooting

If a notebook or shall just hangs whilst scheduling, eg:

```
Scheduling Notebook (remarkably-sought-gecko) (id: 7b36165a-420f-4b45-87f5-612565fd0a5e)...
```

Make sure the cluster has capacity.

During a trial:

```
/opt/conda/bin/python3.6: Error while finding module specification for 'determined.exec.harness' (ModuleNotFoundError: No module named 'determined.exec')
```

Make sure you don't have a directory called determined in your experiment.

If you see `websocket: close 1001 (going away)` in the logs, it generally means the container can't be reached via HTTP.
