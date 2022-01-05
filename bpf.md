# bpf

BPF programs run a restricted set of operations inside the kernel.

BPF tracing programs typically aggregate kernel events, which user space program can read. Whereas perf writes out all perf_events to disk, so generates a lot more I/O

## References

- [What's Wrong with Perf?](https://www.youtube.com/watch?v=0qI31tdlV-k#t=20m15s)
- [The Old Way and The New Way](https://www.youtube.com/watch?v=0qI31tdlV-k#t=29m40s)
- [ebpf -> prometheus](https://blog.cloudflare.com/introducing-ebpf_exporter/)
- [eBPF is AWS Lambda for the Linux kernel](https://twitter.com/tgraf__/status/1059564706640224256?s=19)
