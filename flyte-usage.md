# flyte usage

## Install sandbox

This will start a k3s cluster in docker and then deploy flyte to it. It requires privileged mode, so dind (docker in docker) can be used to build images (see [Getting Started: Scale](https://docs.flyte.org/en/stable/getting_started_scale.html))

```
brew install flyteorg/homebrew-tap/flytectl
flytectl sandbox start --source .
export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config:$HOME/.flyte/k3s/k3s.yaml
export FLYTECTL_CONFIG=$HOME/.flyte/config-sandbox.yaml
```

NB: what does `--source .` do?

You can access flyteconsole on [localhost:30081/console](http://localhost:30081/console).

Register all flytesnacks cookbooks examples by running `flytectl register examples -d development -p flytesnacks`. Workflows are registered in the flytesnacks project, development domain.

To inspect the k3s cluster:

1. switch to the `default` context (defined in $HOME/.flyte/k3s/k3s.yaml)
1. `kubectl get po -A --watch`

Alternatively:

```
# enter sandbox
docker exec -it flyte-sandbox bash

# watch k3s pods
k3s kubectl get po -A --watch
```

## syncresources

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
