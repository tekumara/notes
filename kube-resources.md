# k8s resources

Requests are what the container is guaranteed. Limits are the maximum amount containerd/docker will allow the container to use.

Pods are scheduled based on requests not limits. The scheduler and kubelet ensures the sum of requests of all containers is within the node's allocatable capacity.

Memory:
If a container exceeds the memory limit, the process using the most memory in the container will be OOM killed by the kernel.
If a container exceeds memory requested, the pod may be evicted when another pod needs that memory.

CPU:
A container will be throttled if it exceeds its CPU limit, but will not be killed.

When requests < limits, a pod can opportunistically use resources if they are not being used by other containers. This is called "burstable". This allows over-subscription, but when a pod bursts (up to its limit) it can negatively affect neighbouring pods.

A pod cannot be scheduled on a node when sum(requests) > allocatable cpu. If this is true of all nodes, then the pod will be stuck in pending with "Insufficient cpu".  

See

- [Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits)
- [Resource Quality of Service in Kubernetes](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/node/resource-qos.md)
- [Evicting end-user Pods](https://kubernetes.io/docs/tasks/administer-cluster/out-of-resource/#evicting-end-user-pods)
- [Node OOM Behaviour](https://kubernetes.io/docs/tasks/administer-cluster/out-of-resource/#node-oom-behavior)

## Resource inspection

Show resource quota object for the namespace

```
kubectl get resourcequotas -o yaml
```

Show requests & limits quotas for the namespace

```
kubectl get resourcequotas -o custom-columns="req cpu:.status.hard.requests\.cpu,req mem:.status.hard.requests\.memory,limit cpu:.status.hard.limits\.cpu,limit mem:.status.hard.limits\.memory"
```

Show cpu requests

```shell
kubectl get pods -o jsonpath="{range .items[*]}{.metadata.namespace}:{.metadata.name}{'\n'}{range .spec.containers[*]}  {.name}:{.resources.requests.cpu}{'\n'}{end}{'\n'}{end}"
```

Show request cpu/mem and limit cpu/mem

```shell
kubectl get pods -o jsonpath="pod:container{'\t'}req cpu{'\t'}req mem{'\t'}limit cpu{'\t'}limit mem{'\n'}{range .items[*]}{.metadata.name}:{range .spec.containers[*]}{.name}{'\t'}{.resources.requests.cpu}{'\t'}{.resources.requests.memory}{'\t'}{.resources.limits.cpu}{'\t'}{.resources.limits.memory}{'\n'}{end}{end}" | column -t -s $'\t'
```

Show resources available and allocated across the cluster

```
kubectl describe nodes
```
