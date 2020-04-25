# kubectl

## Contexts & namespaces

Contexts, including the default context, are specified in `~/.kube/config`

`kubectl config get-contexts` list contexts  
`kubectl config use-context docker-desktop` set default context to `docker-desktop`  

`kubectx` lists contexts and allows you to select one with fzf  
`kubectx -c` list current context  

`kubectl config view --minify --output 'jsonpath={..namespace}'` show the current namespace  
`kubens -c` show the current namespace  
`kubens` show all namespaces  

## Inspection

`kubectl version` show client and server versions  
`kubectl get deployments -n kube-system` show deployments for kube itself  
`kubectl get pods -n livy -w` watch pods in the namespace livy  
`kubectl api-resources` show all resource types  
`kubectl get apiservice` show all apiservice resources  
`kubectl get namespaces` show all namespaces  

Show all forwarded ports:
```
kubectl get svc -o json --all-namespaces | jq '.items[] | {name:.metadata.name, p:.spec.ports[] } | select( .p.nodePort != null ) | "\(.name): localhost:\(.p.nodePort) -> \(.p.port) -> \(.p.targetPort)"'
```

### Listing all resources

`kubectl get all --all-namespaces` show "all" kubernetes objects in all namespaces. The "all" type is a pseudo-type that's deprecated, and doesn't cover all resource types (eg: it omits secrets). Resource types included are: pods, services, daemonsets, deployments, replicasets (see [#151](https://github.com/kubernetes/kubectl/issues/151#issuecomment-544247961))
`kubectl get $(kubectl api-resources --verbs=list -o name | paste -sd, -) --ignore-not-found --all-namespaces` actually show all resources

Alternately show all resources using the krew plugin [ketall](https://github.com/corneliusweig/ketall):
```
kubectl krew install get-all
kubectl get-all
```

## Delete

`kubectl delete namespace livy` delete the livy namespace and all resources

### Delete a namespace stuck in the Terminating state

`kubectl get namespaces | grep Terminating` will show namespaces stuck in the *Terminating* state.

To fix, find apiservices that are unavailable:

`kubectl get apiservices | grep False` 

Delete them, and then wait 5 mins.

If that doesn't work, try [knsk.sh](https://github.com/thyarles/knsk)

## Troubleshooting

Container is stuck in state `ContainerCreating`. Check the pod events
```
kubectl describe pods -n livy
```