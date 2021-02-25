# Kubernetes trouble shooting

## Pod In CrashLoopBackOff State and cannot rollback

ie: your pods are in the CrashLoopBackOff state, and you have rolled back/updated the Deployment, but the new replica set hasn't come online, eg:

| Type           | Status | Reason                     |
| -------------- | ------ | -------------------------- |
| Available      | False  | MinimumReplicasUnavailable |
| ReplicaFailure | True   | FailedCreate               |
| Progressing    | True   | ReplicaSetUpdated          |

OldReplicaSets: awesome-api-6b697f966c (6/6 replicas created)
NewReplicaSet: awesome-api-5b78b65549 (0/4 replicas created)

Looking at the events:

```
(combined from similar events): Error creating: pods "awesome-api-5b78b65549-g79mv" is forbidden: exceeded quota: slim, requested: limits.memory=8Gi,requests.memory=8Gi, used: limits.memory=64Gi,requests.memory=64Gi, limited: limits.memory=64Gi,requests.memory=64Gi
```

The new replicas cannot create because of the quota limits.

Solution: manually delete the old replica set.
