# kube pods

## Specs

Basic alpine pod:

```
apiVersion: v1
kind: Pod
metadata:
  name: alpine
spec:
  containers:
  - name: alpine
    image: alpine:latest
```

Privileged with env and volume mounts

```
apiVersion: v1
kind: Pod
metadata:
  name: helper
spec:
  containers:
  - name: alpine
    image: alpine:latest
    env:
    - name: _DIR
      value: /tmp
    - name: _PATH
      value: /usr/sbin:/usr/bin:/sbin:/bin:/bin/aux
    securityContext:
      privileged: true
    volumeMounts:
    - mountPath: /tmp
      name: host-tmp
  volumes:
  - hostPath:
      path: /tmp
      type: Directory
    name: host-tmp
```

## Troubleshooting

### Unknown state

Usually occurs when kube is unable to communicate with the pod's node.

If the pod has already be rescheduled successfully, you can delete the pod.
