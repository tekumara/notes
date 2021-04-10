# Isolate pod from ReplicaSet

The selector determines which pods a ReplicaSet will control. A selector is defined in the Deployment, eg:

```
kubectl get deployment slim-api -o jsonpath="{.spec.selector}" | jq

{
  "matchLabels": {
    "app.kubernetes.io/instance": "awesome-api",
    "app.kubernetes.io/name": "generic-service"
  }
}
```

Each ReplicaSet adds a hash to the selector for the set of pods it controls, eg:

```
kubectl get rs/awesome-api-85d46fc84f -o jsonpath="{.spec.selector}" | jq

{
  "matchLabels": {
    "app.kubernetes.io/instance": "slim-api",
    "app.kubernetes.io/name": "generic-service",
    "pod-template-hash": "85d46fc84f"
  }
}
```

Get a pod's labels:

```
kubectl get pod awesome-api-85d46fc84f-2gf9j -o jsonpath="{.metadata.labels}" | jq

{
  "app": "awesome-api",
  "app.kubernetes.io/instance": "slim-api",
  "app.kubernetes.io/name": "generic-service",
  "pod-template-hash": "85d46fc84f",
  "version": "f182537409c737d7f167990fb11eb4537d17b18e"
}
```

Change a pod's label to remove it from a ReplicaSet:

```
kubectl patch pod awesome-api-85d46fc84f-2gf9j --type json -p '[{"op": "replace", "path": "/metadata/labels/app.kubernetes.io~1instance", "value":"awesome-api-isolated"}]'
```

Ref: [Isolating Pods from a ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/#isolating-pods-from-a-replicaset)
