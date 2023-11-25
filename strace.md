# strace

Syscalls to a specific file

```
strace -c -P /tmp/mylogfile
```

Trace all syscalls with a file arg, for given pid and its forks

```
strace -c -p [pid] -f -yy -e trace=%file
```
