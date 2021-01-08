# helm

## Install Helm v2

```
brew install helm@2

# create a service account and give it cluster-admin privileges
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

# install tiller onto the cluster
helm init --service-account=tiller
```

Verify

```
kubectl get deployments tiller-deploy -n kube-system

NAME            READY   UP-TO-DATE   AVAILABLE   AGE
tiller-deploy   1/1     1            0           15s

# should return nothing
helm list
```

Uninstall

```
kubectl -n kube-system delete deployment tiller-deploy
kubectl delete clusterrolebinding tiller
kubectl -n kube-system delete serviceaccount tiller
```

## Usage

`helm install` install a chart  
`helm upgrade --install` upgrade a release, or install if a release of this name doesn't exist  
`helm --tiller-namespace slim list` list current releases in the slim namespace
`helm --tiller-namespace slim history slim-api` list the history of releases of slim-api
`helm --tiller-namespace slim get slim-api` describe release slim-api
`helm --tiller-namespace slim delete --purge slim-api` delete the release slim-api in the slim namespace
`helm --tiller-namespace slim version -s` show the server tiller version number
`helm --tiller-namespace slim rollback slim-api 0` rollback to previous release of slim-api
`helm repo list` list chart repos
`helm repo update` get lastest version of charts from repos
`helm inspect $repo/$chart` inspect chart $chart from repo $repo
`helm template mychart --values values.yaml` produce a template

## Troubleshooting

### User "system:serviceaccount:kube-system:default" cannot get namespaces in the namespace "default"

This occurs when tiller has been installed but doesn't have cluster admin rights.
Uninstall tiller, create a serviceaccount, bind it to cluster-admin, and then reinstall tiller using that account (see [above](#install-helm-v2)).

### cannot list resource "pods" in API group "" in the namespace "kube-system"

Specify the tiller namespace, eg:
`helm list --tiller-namespace slim`

## Error: error installing: the server could not find the requested resource

See https://github.com/helm/helm/issues/6374
