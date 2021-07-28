# flyte usage


## Install

This will start a k3s cluster in docker and then deploy flyte to it. It requires privileged mode, so dind (docker in docker) can be used to build images.

```
git clone git@github.com:flyteorg/flytesnacks.git
cd flytesnacks

# start ghcr.io/flyteorg/flyte-sandbox:dind
make start
```

You can access flyteconsole on [localhost:30081/console](http://localhost:30081/console). Workflows under _cookbook/_ are registered in the flytesnacks project development domain.

To inspect the k3s cluster:

```
# enter sandbox
docker exec -it flyte-sandbox bash

# watch k3s pods
k3s kubectl get po -A --watch
```

[syncresources](https://github.com/flyteorg/flyte/blob/master/kustomize/base/admindeployment/clustersync/cron.yaml) - a cronjob that runs `flyteadmin --config /etc/flyte/config/*.yaml clusterresource sync` every minute. This [syncs](https://github.com/flyteorg/flyteadmin/blob/2d81c1eec24cffb43346b56fc0017fd29db33a38/cmd/entrypoints/clusterresource.go#L71) cluster resources.

## Install sandbox to existing cluster

```
# install flyte sandbox
kubectl create -f https://raw.githubusercontent.com/lyft/flyte/master/deployment/sandbox/flyte_generated.yaml

# wait 5 mins, until the console comes up
curl http://localhost:30081/console

# install the flytesnacks development workflows
docker run --network host -e FLYTE_PLATFORM_URL='127.0.0.1:30081' lyft/flytesnacks:v0.1.0 pyflyte -p flytesnacks -d development -c sandbox.config register workflows

# follow these instructions https://lyft.github.io/flyte/user/getting_started/examples.html#running-workflows-in-flyte
```
