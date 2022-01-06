# bpftrace

Install

```
sudo apt-get install -y bpftrace
```

Tail file opens

```
sudo opensnoop.bt
```

Show user stacks every time the process 9688 enters `mprotect`:

```
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_mprotect /pid == 9688/ { @[ustack] = count() }'
```

[List probe](https://github.com/iovisor/bpftrace/blob/master/man/adoc/bpftrace.adoc#listing-probes) arguments

```
sudo bpftrace -l 't:syscalls:sys_enter_rename' -v
```

Show usages of the rename syscall:

```
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_rename { printf("%d\t%s\t%s -> %s\n", pid, comm, str(args->oldname), str(args->newname)); }'
```

Show exec calls (no pid, ppid, ret columns like execsnoop-bpfcc so you can see more of the command):

```
sudo execsnoop.bt
```

Show open syscalls with flags and mode (0=O_RDONLY)

```
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_openat { printf("%d\t%s\t%d\t%d\t%s\n", pid, comm, args->flags, args->mode, str(args->filename)); }'
```
