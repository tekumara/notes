# kube requests & limits

Requests are what the container is guaranteed. Limits are the maximum amount the kernel will allow the container to use. Requests cannot be greater than limits.

## Recommendations

The following recommendations are derived from the [EKS best practices guide](https://aws.github.io/aws-eks-best-practices/reliability/docs/dataplane/#configure-and-size-resource-requestslimits-for-all-workloads):

CPU:

- If your app is not optimised for multiple cores don't request more than 1000m CPU.
- Do not specify resource limits on CPU. The request acts as a weight on how much relative CPU time containers get, and no limit avoids throttling. If your cluster requires a limit, make this high enough to avoid throttling.

Memory:

- requests=limits provides the most predictable behaviour.
- requests\<\limits allows oversubscription to improve efficiency
- If requests!=limits, the container has its QOS reduced from Guaranteed to Burstable making it more likely to be evicted in the event of node pressure.
- if you know you need oversubscription to improve efficiency, then set limits > request. However the larger limits are configured relative to requests, the more likely nodes will be overcommitted leading to a higher chance of workload interruption.

## Requests

[Pods are scheduled based on requests](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#how-pods-with-resource-requests-are-scheduled) not limits. The scheduler and kubelet ensures the sum of requests of all containers is within the node's allocatable capacity. A pod cannot be scheduled on a node when sum(requests) > allocatable cpu. If this is true of all nodes, then the pod will be stuck in pending with "Insufficient cpu".

## Limits

A container will be throttled if it exceeds its CPU limit, but will not be killed.

If a container exceeds the memory limit, the process using the most memory in the container will be OOM killed by the kernel.

If a container exceeds memory requested, and the node experiences memory pressure, the pod may be [evicted](https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/#pod-selection-for-kubelet-eviction) or [OOM killed](https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/#node-out-of-memory-behavior). The more their usage level exceeds their requests, the more likely they are to be evicted or OOM killed.

See [How Kubernetes applies resource requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#how-pods-with-resource-limits-are-run).

## Quality of Service Classes

When requests < limits, a pod can opportunistically use resources if they are not being used by other containers. This is known as the `Burstable` QoS class.

When requests = limits for all containers and resources, the pod is assigned the `Guaranteed` QoS class. This is the top priority class. The pod's containers will not be cpu throttled or oom killed unless they exceed limits, or the node is under memory pressure and there are no lower priority containers that can be evicted.

## Unspecified requests or limits

If requests are unspecified and limits are, then [requests are set to limits](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/#what-if-you-specify-a-container-s-limit-but-not-its-request). If limits are unspecified then they default to the [LimitRange in the namespace](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/).

If requests and limits are both unspecified then they both default to their respective LimitRange values. The pod is assigned a `BestEffort` QoS class.

## Memory and bursting

If a lot of burstable pods on the same node burst at the same time to consume memory (a non-compressible resource) they may be OOM killed. Worse, they may interfere with other pods, and in the worst case if [system resources are not correctly reserved](https://kubernetes.io/docs/tasks/administer-cluster/reserve-compute-resources/#) the node can become NotReady, fail, and not recover.

The EKS AMI sets [kubeReserved and evictionHard](https://github.com/awslabs/amazon-eks-ami/blob/165d827/files/bootstrap.sh#L466) but not systemReserved which makes EKS nodes vulnerable to workloads with multiple pods on a single node that burst at the same time beyond memory requests, individually staying below limits, but collectively consuming too much memory and starving the system.

## CPU and requests

CPU requests are a promise of how much CPU the container will receive when the system is at capacity (ie: where there are more runnable tasks than available timeslices). It is used to generate the `cpu.shares` value for each container used by the Linux CFS for scheduling. Idle/unused cpu shares are available for other cgroups to use. Containers can burst beyond their requests to consumer idle cpu shares, but they can't steal share from other processes when those processes are non-idle. For more info see [CPU Shares for Docker containers](https://www.batey.info/cgroup-cpu-shares-for-docker.html)

## References

- [Resource Quality of Service in Kubernetes](https://github.com/kubernetes/design-proposals-archive/blob/main/node/resource-qos.md)
- [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [Node-pressure Eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/)
- [The container throttling problem](https://danluu.com/cgroup-throttling/)

## Resource inspection

Show cpu requests

```shell
kubectl get pods -o jsonpath="{range .items[*]}{.metadata.namespace}:{.metadata.name}{'\n'}{range .spec.containers[*]}  {.name}:{.resources.requests.cpu}{'\n'}{end}{'\n'}{end}"
```

Show request cpu/mem and limit cpu/mem

```shell
kubectl get pods -o jsonpath="pod:container{'\t'}req cpu{'\t'}req mem{'\t'}limit cpu{'\t'}limit mem{'\n'}{range .items[*]}{.metadata.name}:{range .spec.containers[*]}{.name}{'\t'}{.resources.requests.cpu}{'\t'}{.resources.requests.memory}{'\t'}{.resources.limits.cpu}{'\t'}{.resources.limits.memory}{'\n'}{end}{end}" | column -t -s $'\t'
```

Show resource quota object for the namespace

```
kubectl get resourcequotas -o yaml
```

Show requests & limits quotas for the namespace

```
kubectl get resourcequotas -o custom-columns="req cpu:.status.hard.requests\.cpu,req mem:.status.hard.requests\.memory,limit cpu:.status.hard.limits\.cpu,limit mem:.status.hard.limits\.memory"
```

Show limit range for the namespace

```
kubectl get LimitRange -o yaml
```

Show resources available and allocated across the cluster

```
kubectl describe nodes
```
