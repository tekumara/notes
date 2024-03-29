# kubernetes concepts

## Compute

[Pod](https://kubernetes.io/docs/concepts/workloads/pods/) - one or more containers guaranteed to run on the same host. Containers in the pod share networking, storage, and the same lifecycle. A pod is the smallest unit of computing in a kubernetes. A pod isn't usually created directly but as part of a workload resource (eg: Deployment, Job, StatefulSet, DaemonSet). A pod runs a single instance of an application and can be scaled horizontally (aka replication).

### Compute controllers

[ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/) guarantees the availability of a specified number of pods.

A [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) describes the creation or update of a ReplicaSet. It defines a new ReplicaSet and old ReplicaSet.

[DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) - a pod that runs across all (or a subset of) nodes.

[StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) like a deployment but for pods that need a unique stable identity. Among other things, can be used with a volume claim to provide stable persistent storage.

A [PodDisruptionBudget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/) specifies the minimum number of replicas that should exist at a time, and will prevent voluntary disruptions that cause fewer than this number to be available. Involuntary disruptions can still occur.

## Storage

[Volume](https://kubernetes.io/docs/concepts/storage/volumes/) is a directory accessible to all containers in a pod. It survives container restarts.

A [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) has a lifecycle independent of any pod. It is a resource in the cluster provisioned by the cluster administrator or dynamically, and is analogous to a Node.

A PersistentVolumeClaim is request for storage by an application, and is analogous to a Pod.
