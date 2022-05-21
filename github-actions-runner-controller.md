# actions-runner-controller

Ephemeral self-hosted Github actions runner for k8s with DinD.

By default the controller creates a Pod which waits for a github job. When the github job completes the pod is restarted.

Install [cert-manager](https://cert-manager.io/docs/installation/):

```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml
```

## Install using PAT

[Create a PAT](https://github.com/settings/tokens) with:

- repo - all

Install [actions-runner-controller](https://github.com/actions-runner-controller/actions-runner-controller) using a [PAT](https://github.com/actions-runner-controller/actions-runner-controller#setting-up-authentication-with-github-api):

```
 GITHUB_TOKEN=<your PAT>
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm upgrade --install --namespace actions-runner-system --create-namespace \
             --wait actions-runner-controller actions-runner-controller/actions-runner-controller \
             --set-string authSecret.create=true --set-string authSecret.github_token=$GITHUB_TOKEN
```

This creates:

- several [actions.summerwind.dev CRDs](https://github.com/actions-runner-controller/actions-runner-controller/tree/master/charts/actions-runner-controller/crds)
- namespace `actions-runner-system`
- Deployment `actions-runner-controller`
- Pod `actions-runner-controller` with containers `quay.io/brancz/kube-rbac-proxy` and `summerwind/actions-runner-controller`

## GitHub App

1. [Register new GitHub App](https://github.com/settings/apps/new)
1. Required Permissions for Repository Runners without webhook:
   Repository Permissions

   Actions (read)
   Administration (read / write)
   Metadata (read)

1. Use defaults for the rest of the settings.
1. Generate a private key, which is saved to your Downloads directory.
1. Click `Install App` in the left hand menu and select an organisation.
   - If you are admin you'll be able to install it for all repos. If not, you can request it be installed for all repos.
   - If you aren't an admin you can install it on individual repos you own.

## Register runners

Register a runner for an [individual repo](https://github.com/actions-runner-controller/actions-runner-controller#repository-runners):

```
cat <<EOF > runner.yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: Runner
metadata:
  name: example-runner
spec:
  repository: tekumara/asu
  env: []
EOF
kubectl apply -f runner.yaml
```

You can also register runners for an [organisation](https://github.com/actions-runner-controller/actions-runner-controller#organization-runners):

```
cat <<EOF > runner.yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: Runner
metadata:
  name: example-org-runner
spec:
  organization: your-organization-name
EOF
kubectl apply -f runner.yaml
```

This creates:

- a `Runner` resource named `example-runner`
- a Pod in the default namespace named `example-runner` with two containers: `docker:dind` and `summerwind/actions-runner:latest` (see more below).

## Using self-hosted runners in a workflow

To your workflow job add

```
jobs:
  mybuild:
    runs-on: self-hosted
```

See [Using self-hosted runners in a workflow](https://docs.github.com/en/actions/hosting-your-own-runners/using-self-hosted-runners-in-a-workflow)

After a job runs, the runner is restarted unless `ephemeral: false` is set, see [Persistent Runners](https://github.com/actions-runner-controller/actions-runner-controller#persistent-runners).

## Runner image

The `summerwind/actions-runner` image is a stripped-down Ubuntu runner (about 1GB in size). See [Software Installed in the Runner Image](https://github.com/actions-runner-controller/actions-runner-controller#software-installed-in-the-runner-image) and the [Dockerfile](https://github.com/actions-runner-controller/actions-runner-controller/blob/master/runner/Dockerfile).

To run locally set
- RUNNER_NAME
- At least one of RUNNER_ORG or RUNNER_REPO or RUNNER_ENTERPRISE
- RUNNER_TOKEN

Create /runner:

```
sudo mkdir runner
```

Then run /entrypoint.sh

## Uninstall

```
helm uninstall --namespace actions-runner-system actions-runner-controller
```
