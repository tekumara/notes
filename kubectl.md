# kubectl

## Contexts & namespaces

`$KUBECONFIG` can be set to a colon separated list of config files. If unset it will default to `~/.kube/config`

Clusters, users and contexts are specified in the config files. The first config file in `$KUBECONFIG` contains the `current-context` key which specifies the current context.

`kubectl config get-contexts` list contexts  
`kubectl config use-context docker-desktop` set current context to *docker-desktop*   
`kubectl config view --minify --output 'jsonpath={..namespace}'` show the current namespace

Alternatively using [kubectx](https://github.com/ahmetb/kubectx):

`kubectx` lists contexts and allows you to select one with fzf as the current context  
`kubectx -c` list current context  

`kubens` show all namespaces  
`kubens -c` show the current namespace

## Dry runs

To see the effects of commands that modify the cluster (eg: apply/path), add `--dry-run=client -o yaml | less`

## Inspection

`kubectl version` show client and server versions  
`kubectl get deployments -n kube-system` show deployments for kube itself  
`kubectl get pods -n livy -w` watch pods in the namespace livy  
`kubectl api-resources` show all resource types  
`kubectl get apiservice` show all apiservice resources  
`kubectl get namespaces` show all namespaces  
`kubectl top nodes` show CPU/MEM for nodes
`kubectl top pods -A` show CPU/MEM for pods in all namespaces

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

## Patch

Set the contents of the args array
```
kubectl patch deployment metrics-server -n kube-system -p '{"spec": {"template": {"spec":{"containers":[{"name":"metrics-server","args":["--cert-dir=/tmp","--secure-port=4443"]}]}}}}' 
```

Insert an element into the head of the args array
```
kubectl patch deployment metrics-server -n kube-system --type json -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/0", "value":"--kubelet-insecure-tls"}]' 
```

## Delete

`kubectl delete namespace livy` delete the livy namespace and all resources
`kubectl delete -f <file.yml>` delete the resources in the file

### Delete a namespace stuck in the Terminating state

`kubectl get namespaces | grep Terminating` will show namespaces stuck in the *Terminating* state.

To fix, find apiservices that are unavailable:

`kubectl get apiservices | grep False` 

Delete them, and then wait 5 mins.

If that doesn't work, try [knsk.sh](https://github.com/thyarles/knsk)

## Merge two config files
```
(KUBECONFIG=~/.kube/config:~/someotherconfig && kubectl config view --flatten > ~/.kube/config.new)
```


## Troubleshooting

### Container is stuck in state `ContainerCreating`

Usually means there's an issuing downloading the container. Check the pod events:
```
kubectl describe pods -n livy
```

### error: metrics not available yet

If you see this when running `kubectrl top nodes` then you need to install and enable the metrics server.