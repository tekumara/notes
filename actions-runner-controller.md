# actions-runner-controller

A k8s self-hosted Github actions runner for k8s.

By default the controller creates a Pod which waits for a job. When the job completes the pod is recycled.

Install [cert-manager](https://cert-manager.io/docs/installation/):

```
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.yaml
```

Create a PAT with:

- repo - all
- admin:org - all

Install [actions-runner-controller](https://github.com/actions-runner-controller/actions-runner-controller) using a [PAT](https://github.com/actions-runner-controller/actions-runner-controller#setting-up-authentication-with-github-api):

```
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm upgrade --install --namespace actions-runner-system --create-namespace \
             --wait actions-runner-controller actions-runner-controller/actions-runner-controller \
             --set-string authSecret.create=true --set-string authSecret.github_token=FOOBAR
```

Register a runner for an an [individual repo](https://github.com/actions-runner-controller/actions-runner-controller#repository-runners):

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

You can also register for runners for an [organisation](https://github.com/actions-runner-controller/actions-runner-controller#organization-runners):

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

Uninstall

```
helm uninstall --namespace actions-runner-system actions-runner-controller
```
