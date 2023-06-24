# ps

## ps (BSD)

Show RSS in Kb

```
ps -A -m -o pid,vsz,rss,%mem,command
```

Show all stopped processes

```
ps -o stat,command,pid | grep '^S+'
```

## ps (GNU)

Human-friendly memory stats:

```
ps -eo pmem,comm,pid,maj_flt,min_flt,rss,vsz,etimes --sort -rss | numfmt --header --to=iec --field 4-5 | numfmt --header --from-unit=1024 --to=iec --field 6-7 | column -t | head

# or ps ux | numfmt --header --to=iec --field 5,6 --padding 10 | column -t
```

```
ps -eo pid,ppid,user,class,rtprio,ni,pri,psr,pcpu,stat,wchan:14,comm,cmd
```

To show full listing, with hierarchy, of only your own processes:

```
ps -fH  -u `whoami`
```

Sort by resident memory usage desc

```
ps aux --sort -rss
```

For the elastic process, and the header, sorted by resident memory desc

```
ps ux --sort -rss | grep "RSS\|elastic"
```

Watch memory on pid 12611, with datetime

```
{ ps u | head -n1; while sleep 1; do COLUMNS=120 ps uh -q 12611; done } |  gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }'
```

See also `pidstat -r 1` which will show a rolling summary of changes to page fault and memory stats by pid

See all child threads in a tree created by PID 4099, collapsing threads with the same name

```
pstree 4099
```

See all child threads created by PID 4099, individually with their PID

```
ps -p 4099
```

See parents, and children, of PID 4099, individually with their PID

```
ps -s -p 4099
```
