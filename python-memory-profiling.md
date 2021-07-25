# python memory profiling

pympler - profile by explicit instrumentation
heaptrack - instrument running process

[tracemalloc example](https://github.com/edgedb/edgedb/blob/d4eacfd59f7920d1f0255e19a772301167342ce6/edb/tools/profiling/profiler.py#L275)

## enable coredump on abort

ulimit -c unlimited

python scripts/abort.py 

gcore (part of gdb) dumps a running program

[inside a container might be tricky

See also:
[Documentation: Make clear instructions for getting a core file, when container crashes](https://github.com/moby/moby/issues/11740)
