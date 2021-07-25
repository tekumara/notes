# kube probes

The container will get recycled if its not in the ready state after:

```
initialDelaySeconds + (failureThreshold * periodSeconds) seconds = 65 secs
```

## Resources

[Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes)
