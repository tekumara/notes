# determined-ai

Determined AI provides cluster management for model training, and offer the following [benefits](https://docs.determined.ai/latest/topic-guides/benefits-of-determined.html):

* elastic scheduling of containers on GPUs for model training, including fair-sharing with pre-emption. Pre-empted training tasks checkpoint their state before terminating gracefully
* elastic scheduling of notebooks, tensorboards, commands and shells on CPUs
* [multi-machine distributed training](https://docs.determined.ai/latest/topic-guides/effective-distributed-training.html#effective-distributed-training) built on top of [NVIDIA/nccl](https://github.com/NVIDIA/nccl) and [facebookincubator/gloo](https://github.com/facebookincubator/gloo)
* state-of-the-art hyperparameter tuning algorithm ([ASHA](https://arxiv.org/abs/1810.05934))
* a high-performance random-access data layer ([yogadl](https://docs.determined.ai/latest/how-to/data-layer.html)) that locally caches data read from cloud storage. Enables transparent data sharding across multiple-machines, and resuming training mid-epoch.
* experiment tracking
* team based - resources and experiment results are shared and accessible to any team member with access

On the roadmap:

* model store
* spot instances on AWS
* a kubernetes scheduler
* RBAC

Enterprise edition:

* Okta integration (SAML, SCIM)
* Support & product development
* More high-end offerings to come

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

* postgres
* [determined-agent](https://github.com/determined-ai/determined/tree/master/agent)
* [determined-master](https://github.com/determined-ai/determined/tree/master/master)

They are connected by a docker bridge network.
The master UI is served on http://localhost:8080 with user `admin` and no password.

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
`det shell start` Start a shell on the cluster
`det experiment create const.yaml .` Create experiment defined in *const.yaml* with model def in current dir
`det tensorboard start 1` Start tensorboard to inspect experiment 1

## Determined container images

* docker hub: [determinedai/environments](https://hub.docker.com/r/determinedai/environments/tags)
* github: [determined/environments](https://github.com/determined-ai/environments) 
