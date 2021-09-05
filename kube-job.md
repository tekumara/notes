# kube-job

A Job, like a Deployment, is a higher level abstraction that uses pods to run a completable task.

A pod can be started with `restartPolicy: Never` to run a completable task. But in the event of node failure, the Job operator will reschedule the pod to another node. An unmanaged pod will not be rescheduled.
