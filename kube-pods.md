# kube pods

## Specs

- [Basic alpine pod](kube/alpine.yaml)
- [Privileged with env and volume mounts](kube/buildkit.yaml)

## Entrypoint

| Description                         | Docker field name | Kubernetes field name |
| ----------------------------------- | ----------------- | --------------------- |
| The command run by the container    | Entrypoint        | command               |
| The arguments passed to the command | Cmd               | args                  |

## Troubleshooting

### Unknown state

Usually occurs when kube is unable to communicate with the pod's node.

If the pod has already be rescheduled successfully, you can delete the pod.
