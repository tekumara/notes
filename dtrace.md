# dtrace

`sample PID 60 1 -file sample.txt` profile call stacks for 60 secs every 1ms

## Tracing syscalls

`sudo dtruss -p <pid>` show syscalls of pid
`sudo dtruss -n python3` show syscalls of any current or future python3 processes
`sudo dtruss pip` start `pip` and show syscalls NB: pip will run as root
`sudo dtruss -p <pid> -f` follow children as they are forked. This is useful for watching processes started from the shell. Use `echo $$` to get the shell's pid. However it will show the shell's syscalls too, which gets noisy.

## iosnoop

`sudo iosnoop -n python3` show disk I/O (block, size, filename) for the python3 process. NB: does not show `stat64` calls.

## Misc

`dtrace -qwn 'proc:::exec-success /execname=="java"/{trace(pid);stop();exit(0)}` stop a process when it starts to get its pid [ref](see https://stackoverflow.com/a/22029929/149412)

## system integrity protection is on, some features will not be available / dtrace: invalid probe specifier

OS X El Captain introduced [System Integrity Protection](https://derflounder.wordpress.com/2015/10/01/system-integrity-protection-adding-another-layer-to-apples-security-model/) which limits the actions that the root user can perform on protected parts of the Mac operating system.

`csrutil status` will tell you if SIP is enabled.

To enable dtrace:

- Reboot the mac
- Hold ⌘R during reboot to enter the Recovery OS.
- From the Utilities menu, run Terminal
- Run `csrutil enable --without dtrace` which should report "This is an unsupported configuration".

## References

[Top 10 DTrace scripts for Mac OS X](http://dtrace.org/blogs/brendan/2011/10/10/top-10-dtrace-scripts-for-mac-os-x/)
