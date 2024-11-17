# load average

A measure of demand for CPU time.

`uptime` load average = number of tasks (processes) waiting to run on CPU + processes blocked by uninterruptible I/O.

`vmstat` the `r` column - just number of tasks waiting to run, does not include I/O. If greater than CPU count = saturation.

util average = actual utilisation of CPU timeslices.

[Linux Performance Analysis in 60,000 Milliseconds](https://netflixtechblog.com/linux-performance-analysis-in-60-000-milliseconds-accc10403c55)

## Saturation

For time-sensitive operations: If your system handles critical, time-sensitive tasks, you should aim to keep the load average below 1.0 per CPU core.

For non-time-sensitive operations: If your system processes background tasks or jobs that aren't time-sensitive, you can tolerate higher load averages.

https://www.logicmonitor.com/blog/what-the-heck-is-cpu-load-on-a-linux-machine-and-why-do-i-care


## PELT

se.wait_max = waited to run on cpu
se.block_max = blocked on i/o

* [ref](https://lwn.net/Articles/242900/)

Util avg : running time
Load_avg : runnable time weighted with nice priority
Runnable_load_avg : For rq, this is the /Sum load of runnable entities


https://www.youtube.com/watch?v=2-KJsRPHfz8

https://github.com/torvalds/linux/blob/master/kernel/sched/pelt.c
