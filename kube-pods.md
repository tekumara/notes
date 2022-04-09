# kube pods

## Specs

- [Basic alpine pod](kube/alpine.yaml)
- [Privileged with env and volume mounts](kube/buildkit.yaml)

## Troubleshooting

### Unknown state

Usually occurs when kube is unable to communicate with the pod's node.

If the pod has already be rescheduled successfully, you can delete the pod.
