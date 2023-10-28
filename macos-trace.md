# tracing on macOS

## Call stacks

`sample $PID 60 1 -file sample.txt` profile call stacks for 60 secs every 1ms

## Tracing syscalls

`sudo dtruss -p <pid>` show syscalls of pid
`sudo dtruss -n cron` show syscalls of any current or future `cron*` processes
`sudo dtruss pip` start `pip` and show syscalls NB: pip will run as root
`sudo dtruss -p <pid> -f` follow children as they are forked. This is useful for watching processes started from the shell. Use `echo $$` to get the shell's pid. However it will show the shell's syscalls too, which gets noisy.

`sudo sc_usage myapp` top-like sampling of syscalls every 1 secs from already running `myapp` process. Use `-E` to start a command.

## File system

`lsof -c ssh-agent` files ssh-agent currently has open
`sudo fs_usage -w` tail filesystem sys calls and page faults (includes fstat64 calls)
`sudo fs_usage -w -f filesys` watch filesystem sys calls
`sudo fs_usage -w -f filesys | grep mds` watch filesystem sys calls made by the `mds_stores` process
`sudo opensnoop -f ~/.ssh/github` tail file opens
`sudo iosnoop -n python3` tail disk I/O (block, size, filename) for the python3 process. NB: does not show `stat64` calls, or cached file access.

NB: `fs_usage` and `opensnoop` don't include `chdir` syscalls. So you'll be missing the full path the program uses relative paths. Use dtruss instead.

## Processes

`sudo fs_usage -w -f exec | grep typos` watch exec/spawn syscalls (ie: new processes) that start with `typos`.
`sudo execsnoop -v` tail all new process execution
`sudo execsnoop -v -c python` tail all new process execution for commands starting with `python*`
`sudo newproc.d` tail all new process execution with their command line args - nb: this is expensive and can crash the system. Instead, stop the process (see below) and use `ps` to inspect the args.

## Network

`netstat -p tcp` list all tcp connections
`lsof -i tcp` list all tcp connections and their processes

## Misc

`dtrace -qwn 'proc:::exec-success /execname=="python3.9"/{printf("%d\n",pid);stop()}'` stop a process when it starts to get its pid. To resume: `kill -CONT <pid>` ([ref](https://stackoverflow.com/a/22029929/149412)).
`man -k dtrace` show man pages for all dtrace scripts

## dtrace scripts

`dtrace -s /usr/bin/newproc.d` is equivalent to `newproc.d` when _newproc.d_ is on the path.

## Troubleshooting

> system integrity protection is on, some features will not be available / dtrace: invalid probe specifier

dtrace and the dtrace scripts above (ie: dtruss, \*snoop, newproc.d) don't work with System Integrity Protection (SIP) enabled. See [Disable SIP for dtrace](macos-sip.md#disable-sip-for-dtrace).

If you can't disable SIP, because you are using a VM, you can still use `fs_usage` and other non-dtrace scripts. See [Using dtrace on MacOS with SIP enabled](https://poweruser.blog/using-dtrace-with-sip-enabled-3826a352e64b).

> system freezes during dtrace / dtruss

[dtrace is broken on Ventura](https://apple.stackexchange.com/questions/457227/how-to-debug-a-freezing-dtrace-on-ventura) :-(

dtrace scripts can generate a large amount of data, which can cause memory to spike and the system to freeze. Use filters provided by script arguments to avoid this.

## References

- [Top 10 DTrace scripts for Mac OS X](http://dtrace.org/blogs/brendan/2011/10/10/top-10-dtrace-scripts-for-mac-os-x/)
- [USE Method: Mac OS X Performance Checklist (2014)](https://www.brendangregg.com/USEmethod/use-macosx.html)
