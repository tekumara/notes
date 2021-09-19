# kubectl

## Install

Alpine: `apk add kubectl --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing`
macOS: `brew install kubernetes-cli`
Linux binary: `curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"`

## Contexts & namespaces

`$KUBECONFIG` can be set to a colon separated list of config files. If unset it will default to `~/.kube/config`

Clusters, users and contexts are specified in the config files. The first config file in `$KUBECONFIG` contains the `current-context` key which specifies the current context.

`kubectl config get-contexts` list contexts  
`kubectl config use-context docker-desktop` set current context to _docker-desktop_  
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
`kubectl get service --namespace jhub` get services in the jub namespace
`kubectl get endpoints` get endpoints objects, ie: IP addresses of pods for a service
`kubectl get pods -n livy -w` watch pods in the namespace livy  
`kubectl get pods --namespace=jhub -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}'` list pods and their running container images
`kubectl get pods -o wide` list pods and the node they are running on  
`kubectl api-resources` show all resource types  
`kubectl get apiservice` show all apiservice resources  
`kubectl get namespaces` show all namespaces  
`kubectl get nodes` list node details including IP address, capacity, resources requests and limits  
`kubectl top nodes` show CPU/MEM usage for nodes
`kubectl top pods` show CPU/MEM usage for pods in current namespace
`kubectl top pods -A` show CPU/MEM usage for pods in all namespaces  
`kubectl describe rs/hub-67966db58b -n jhub` describe the replicaset hub-67966db58b in namespace  
`kubectl get events --sort-by='{.lastTimestamp}'` show events sorted by last seen timestamp. NB: by default events are only kept by the api server for 1 hour
`kubectl describe ingress` describe ingress objects
`kubectl rollout restart deployment awesome-api` do a rolling restart of a deployment
`kubectl logs -f $PODNAME` stream logs
`kubectl get ingress -n flyteexamples-development -o jsonpath='{range .items[*]}{"\n"}http://localhost:30081{.spec.rules[*].http.paths[*].path}{end}'` show ingress paths (ignores host)
`kubectl auth can-i --list` show all the actions I have in the current namespace
`kubectl get role app-admin -o yaml` show details of a role
`kubectl exec -i -t $pod -- /bin/bash` get interactive shell

Show all forwarded ports, ie: [NodePort services](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types):

```
kubectl get svc -o json --all-namespaces | jq '.items[] | {name:.metadata.name, p:.spec.ports[] } | select( .p.nodePort != null ) | "\(.name): localhost:\(.p.nodePort) -> \(.p.port) -> \(.p.targetPort)"'
```

Show deployment status

```
kubectl get deployment slim-api -o jsonpath="{range .status.conditions[*]}{.lastUpdateTime}{'\t'}{.reason}{'\t'}{.message}{'\n'}{end}"
```

### Run interactively

`kubectl run -it --image=alpine helper` starts an pod called _helper_ running the alpine image in the cluster with requests/limits of 250m cpu 1Gi mem
`kubectl run -it --image=ubuntu --requests "cpu=50m" helper` starts an ubuntu pod with
`kubectl run it --image=ubuntu -o yaml --dry-run=client` show the deployment object buy don't apply it
`kubectl delete pod helper` delete the helper pod
`kubectl cp $namespace/$pod:/app/heaptrack.gunicorn.2983.gz heaptrack.gunicorn.2983.gz` copy file from pod to local dir

### Listing all resources

`kubectl get all --all-namespaces` show "all" kubernetes objects in all namespaces. The "all" type is a pseudo-type that's deprecated, and doesn't cover all resource types (eg: it omits secrets, roles, service accounts, rolebindings). Resource types included are: pods, services, daemonsets, deployments, replicasets (see [#151](https://github.com/kubernetes/kubectl/issues/151#issuecomment-544247961))  
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

`--type json` in the above uses [JSON Patch](https://tools.ietf.org/html/rfc6902), which in turn uses [JSON Pointer](https://tools.ietf.org/html/rfc6901) for identifying JSON values (eg: `/foo/0` = the first element of the foo array)

## Delete

`kubectl delete namespace livy` delete the livy namespace and all resources
`kubectl delete -f <file.yml>` delete the resources in the file
`kubectl delete deployment slim-api` delete a deployment

### Delete a namespace stuck in the Terminating state

`kubectl get namespaces | grep Terminating` will show namespaces stuck in the _Terminating_ state.

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

### evicted

Check the pod events:

```
kubectl describe pods -n projectcontour
```

### The node had condition: [DiskPressure]

Free disk space on the node.
