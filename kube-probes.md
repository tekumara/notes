# kube probes

## Types of probe

> [!WARNING]
> Avoid checking dependencies in the liveness probe and be conservative with checking them in the readiness probe as it can lead to cascading health check failures.

Readiness Probe

- Checks if the container is ready to accept traffic.
- If it fails, the pod is removed from service endpoints (no traffic sent).
- Runs throughout the container’s lifecycle.

Liveness Probe

- Checks if the container is still running and healthy.
- If it fails, the container is restarted.
- Used to detect and remedy deadlocks or stuck containers.

The container will restart if not live after:

```
initialDelaySeconds + (failureThreshold * periodSeconds) seconds
```

> Liveness probes can be a powerful way to recover from application failures, but they should be used with caution. Liveness probes must be configured carefully to ensure that they truly indicate unrecoverable application failure, for example a deadlock.
>
> Incorrect implementation of liveness probes can lead to cascading failures. This results in restarting of container under high load; failed client requests as your application became less scalable; and increased workload on remaining pods due to some failed pods. Understand the difference between readiness and liveness probes and when to apply them for your app.

Startup Probe

- Checks if the application within the container has started.
- Used for slow-starting containers.
- Disables liveness and readiness probes until it succeeds. The pod won't be ready until the startup probe finishes and the readiness check can run.
- If it fails, the container is killed and restarted.

> Startup probes are useful for Pods that have containers that take a long time to come into service. Rather than set a long liveness interval, you can configure a separate configuration for probing the container as it starts up, allowing a time longer than the liveness interval would allow.

## Ready condition

A pod is ready when its [`Ready` condition](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-conditions) is true.

All pods have the ready condition regardless of whether they are part of a service. For pods attached to a service, the ready condition is used to add / remove them from the service.

Helm with `--wait` helm will wait until resources are in the ready state, ie: for pods, the `Ready` condition true.

## Resources

- [Types of probe](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#types-of-probe).
- [Kubernetes Liveness and Readiness Probes: How to Avoid Shooting Yourself in the Foot](https://blog.colinbreck.com/kubernetes-liveness-and-readiness-probes-how-to-avoid-shooting-yourself-in-the-foot/)
- [Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes)
