# kube nodes

## Reclaiming disk space

When filesystem eviction thresholds have been met, kubelet will try to free disk space by garbage collecting dead pods and containers, and deleting unused images.

See

- [Reclaiming node level resources](https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/#reclaim-node-resources)
- [kubelet](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)

## DiskPressure

Occurs when disk is less than 10% free.

Free some disk space. If that doesn't work, remove the taint from the node directly: `kubectl edit node`

See [Node-pressure Eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/)
