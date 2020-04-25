# helm

## Install Helm v2

```
brew install helm@2

# create a service account and give it cluster admin privileges
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

# install tiller onto the cluster
helm init --service-account=tiller
```

Verify
```
# should return nothing
helm list
```

```
kubectl get deployments tiller-deploy -n kube-system

NAME            READY   UP-TO-DATE   AVAILABLE   AGE
tiller-deploy   0/1     1            0           15s
```

Uninstall
```
kubectl -n kube-system delete deployment tiller-deploy
kubectl delete clusterrolebinding tiller
kubectl -n kube-system delete serviceaccount tiller
```

## Inspection

`helm list` list released

## Deleting a chart

`helm uninstall livy` delete the livy release. This does not delete all cluster resources.

## Troubleshooting

### User "system:serviceaccount:kube-system:default" cannot get namespaces in the namespace "default"

This occurs when tiller has been installed but doesn't have cluster admin rights.
Uninstall tiller, create a serviceaccount, bind it to cluster-admin, and then reinstall tiller using that account (see [above](#install-helm-v2)).
