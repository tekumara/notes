# profiling

Off cpu is time spent waiting (eg: for I/O) and affects the latency of an individual request. This won't be visible in a CPU profiler. One way to tackle this is to add telemetry to the request path.

Under load the CPU profile might change as new bottlenecks are revealed, eg: lock contention might only appear under load.
