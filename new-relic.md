# new relic

% of running time the app was throttled

```
FROM K8sContainerSample SELECT sum(containerCpuCfsThrottledPeriodsDelta) / sum(containerCpuCfsPeriodsDelta) * 100 WHERE clusterName = 'mycluster' AND containerName='my container' FACET  podName TIMESERIES 1 MINUTE SINCE 3 hours ago
```
