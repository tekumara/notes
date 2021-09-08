# actions-runner-controller

Install [cert-manager](https://cert-manager.io/docs/installation/):

```
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.yaml
```

Create a PAT with:

- repo - all
- admin:org - all

Install [actions-runner-controller](https://github.com/actions-runner-controller/actions-runner-controller) using a [PAT](https://github.com/actions-runner-controller/actions-runner-controller#setting-up-authentication-with-github-api):

```
echo 'authSecret.github_token=FOOBAR' > values.yaml
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm upgrade --install --namespace actions-runner-system --create-namespace \
             --wait actions-runner-controller actions-runner-controller/actions-runner-controller \
             --set-string authSecret.create=true --set-string authSecret.github_token=FOOBAR
```

Register a runner for an organisation:

```
cat <<EOF > runner.yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: Runner
metadata:
  name: example-org-runner
spec:
  organization: your-organization-name
EOF
```

kubectl apply -f runner.yaml

You can also register for an [individual repo](https://github.com/actions-runner-controller/actions-runner-controller#repository-runners)

Uninstall

```
helm uninstall --namespace actions-runner-system actions-runner-controller
```
