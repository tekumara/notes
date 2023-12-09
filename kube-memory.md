# kube-memory

`kubectl top pod` = container_memory_working_set_bytes

same as

```
cat /sys/fs/cgroup/memory/memory.usage_in_bytes
```

([ref](https://octopus.com/blog/kubernetes-pod-cpu-memory))
