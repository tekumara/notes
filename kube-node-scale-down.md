# kube node scale down (WIP)

We've set `terminationGracePeriodSeconds` but this doesn't seem to prevent our pods from dying during a Kubernetes scale down event

The pod was configured with `terminationGracePeriodSeconds: 14400` and `restartPolicy: Never`

I’ve tried manually testing `terminationGracePeriodSeconds` by starting these pods and then using kubectl delete pod to terminate them.

It looks like it works, ie: the pod doesn’t stop immediately but keeps running until its workload completes.

However, when a node scale down event is the cause of the termination, it looks like the pod either immediately dies, or keeps running for another ~6 mins and then dies.

See [Graceful node shutdown](https://kubernetes.io/docs/concepts/architecture/nodes/#graceful-node-shutdown).

From [KEP-2000](https://github.com/kubernetes/enhancements/tree/master/keps/sig-node/2000-graceful-node-shutdown):

> Upon shutdown Kubelet will:
>
> 1. Update the Node’s Ready condition to false, with the reason Node is shutting down
> 2. Gracefully terminate all non critical system pods with a gracePeriodOverride computed as min(podSpec.terminationGracePeriodSeconds, ShutdownGracePeriod-ShutdownGracePeriodCriticalPods)
> 3. Gracefully terminate all critical system pods with gracePeriodOverride of ShutdownGracePeriodCriticalPods seconds

So if `ShutdownGracePeriod` is 0 (the default) then it looks like it effectively overrides the pod’s `terminationGracePeriodSeconds` and will terminate straight away?

We have a response from aws support:

> 2. For the cluster autoscaler for example, from version 1.0, gives pods at most 10 minutes graceful termination time by default (configurable via --max-graceful-termination-sec). If the pod is not stopped within these 10 min then the node is terminated anyway. Earlier versions of CA gave 1 minute or didn't respect graceful termination at all, please refer to [3]

We use cluster-autoscaler version 1.21 which will allow maximum of 10 mins before node is terminated.
They also mentioned this

> 3. Please note that for self managed node group there is no draining mechanism yet, and there is an existing feature request here [4], but I would not be able to provide you with an ETA on when the new container version would be released, as this is something which is internal to the service team

Thanks for pointing out the max-graceful-termination-sec setting in the [autoscaler faq](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#does-ca-respect-gracefultermination-in-scale-down).

I think you could try `cluster-autoscaler.kubernetes.io/safe-to-evict": "false"` , but again, if control plane sets the node to be in NotReady state due to any reason (network hiccup / or anything), I don't think it'll care for this flag.
And --max-graceful-termination-sec would only be honoured for 600 seconds and then the node will be terminated regardless, as per AWS support.
