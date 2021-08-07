# flyte install sandbox

## Install sandbox

This will start a [docker container](https://github.com/flyteorg/flyte/blob/2438f30f3c94c49866eefd992937fec8bea9718e/docker/sandbox/Dockerfile) running a k3s cluster with flyte deployed to it. It requires privileged mode, so dind (docker in docker) can be used to build images.

```
brew install flyteorg/homebrew-tap/flytectl
flytectl sandbox start --source $HOME/code3/flytesnacks
export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config:$HOME/.flyte/k3s/k3s.yaml
export FLYTECTL_CONFIG=$HOME/.flyte/config-sandbox.yaml
```

(from [Getting Started: Scale](https://docs.flyte.org/en/stable/getting_started_scale.html))

You can access flyteconsole on [localhost:30081/console](http://localhost:30081/console).

`--source mydir` mounts _mydir_ at _/root_ in the sandbox docker container. _/root_ is the working directory when building images inside the sandbox, ie: in `flytectl sandbox exec -- docker build .` the _._ is _/root_.

Register all flytesnacks cookbook examples in the flytesnacks project, development domain follow [Setting up your environment to run the examples](https://docs.flyte.org/projects/cookbook/en/latest/#setting-up-your-environment-to-run-the-examples) or

```
flytectl register examples -d development -p flytesnacks
```

## Inspect the k3s cluster

1. switch to the `default` context (defined in _$HOME/.flyte/k3s/k3s.yaml_)
1. `kubectl get po -A --watch`

Alternatively:

```
# enter sandbox
docker exec -it flyte-sandbox bash

# watch k3s pods
k3s kubectl get po -A --watch
```

## Other

Status

```
flytectl sandbox status
```

Stop sandbox and delete image

```
flytectl sandbox teardown
```

Start existing container

```
docker start flyte-sandbox
```

## pods

[syncresources](https://github.com/flyteorg/flyte/blob/master/kustomize/base/admindeployment/clustersync/cron.yaml) - a cronjob that runs `flyteadmin --config /etc/flyte/config/*.yaml clusterresource sync` every minute. This [syncs](https://github.com/flyteorg/flyteadmin/blob/2d81c1eec24cffb43346b56fc0017fd29db33a38/cmd/entrypoints/clusterresource.go#L71) cluster resources.

[flyte-pod-webhook](https://github.com/flyteorg/flytepropeller/blob/b2af2cdb411c25be5659160cb97b0a3ab6234f61/pkg/webhook/pod.go) - intercepts prod creations events for injecting things like secrets.

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
