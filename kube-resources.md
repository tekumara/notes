# k8s resources

Requests are what the container is guaranteed. Limits are the maximum amount the kernel will allow the container to use. Requests cannot be greater than limits.

## Scheduling

[Pods are scheduled based on requests](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#how-pods-with-resource-requests-are-scheduled) not limits. The scheduler and kubelet ensures the sum of requests of all containers is within the node's allocatable capacity. A pod cannot be scheduled on a node when sum(requests) > allocatable cpu. If this is true of all nodes, then the pod will be stuck in pending with "Insufficient cpu".

## Limits

A container will be throttled if it exceeds its CPU limit, but will not be killed.

If a container exceeds the memory limit, the process using the most memory in the container will be OOM killed by the kernel.
If a container exceeds memory requested, the pod may be evicted when another pod needs that memory.

See [How Kubernetes applies resource requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#how-pods-with-resource-limits-are-run).

## Burstable

When requests < limits, a pod can opportunistically use resources if they are not being used by other containers. This is called "burstable".

However, if a lot of pods on the same node burst at the same time to consume memory (a non-compressible resource) they may be OOM killed. Worse, they may interfere with other pods, and in the worst case if [system resources are not correctly reserved](https://kubernetes.io/docs/tasks/administer-cluster/reserve-compute-resources/#) the node can become NotReady, fail, and not recover.

The EKS AMI sets [kubeReserved and evictionHard](https://github.com/awslabs/amazon-eks-ami/blob/165d827/files/bootstrap.sh#L466) but not systemReserved which makes EKS nodes vulnerable to workloads with multiple pods on a single node that burst at the same time beyond memory requests, individually staying below limits, but collectively consuming too much memory and starving the system.

## Unspecified requests or limits

If requests are unspecified and limits are, then [requests = limits](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/#what-if-you-specify-a-container-s-limit-but-not-its-request). If limits are unspecified then they default to the [LimitRange in the namespace](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/). If requests and limits are both unspecified then they both default to their respective LimitRange values.

## Recommendations

General guidance for sizing resource requests and limits from the [EKS best practices guide](https://aws.github.io/aws-eks-best-practices/reliability/docs/dataplane/#configure-and-size-resource-requestslimits-for-all-workloads):

> - Do not specify resource limits on CPU. In the absence of limits, the request acts as a weight on how much relative CPU time containers get. This allows your workloads to use the full CPU without an artificial limit or starvation.
> - For non-CPU resources, configuring requests=limits provides the most predictable behavior. If requests!=limits, the container also has its QOS reduced from Guaranteed to Burstable making it more likely to be evicted in the event of node pressure.
> - For non-CPU resources, do not specify a limit that is much larger than the request. The larger limits are configured relative to requests, the more likely nodes will be overcommitted leading to high chances of workload interruption.

In addition:

- If your app is not optimised for multiple cores do not request more than 1000m CPU.

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
