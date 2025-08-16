# fio

```
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --bs=4k --iodepth=64 --readwrite=randrw --rwmixread=50 --size=1G
```

--randrepeat=1

Ensures reproducible results by using the same random seed
Same "random" I/O pattern will be generated each run
Useful for consistent benchmarking

--name=test

Job name identifier (shows as "test" in output)
Helps identify results when running multiple jobs

--ioengine=libaio

Uses Linux native asynchronous I/O
Allows multiple I/O operations to be submitted without waiting
More efficient than synchronous I/O for high queue depths

--direct=1

Bypasses operating system page cache (O_DIRECT flag)
Tests raw storage performance, not cached data
Forces I/O to go directly to storage device

--gtod_reduce=1

Reduces gettimeofday() system calls for better performance
Less precise timestamps but lower overhead
Helps when running high IOPS tests

--iodepth=64

Queue depth: 64 I/O operations can be outstanding simultaneously
Higher queue depth often improves throughput on modern storage
Simulates heavy concurrent workload

--bs=4k

Block size: Each I/O operation is 4KB
Common size for database and random access patterns
Good for testing IOPS performance

--readwrite=randrw

Random read/write mix pattern
I/O operations happen at random locations in the file

--rwmixread=50

50% of operations are reads, 50% are writes
Simulates balanced read/write workload
Default is 50/50 if not specified

--size=1G

Creates and tests against a 1GB file
Larger than typical RAM to avoid cache effects
Provides enough data for meaningful random I/O patterns
