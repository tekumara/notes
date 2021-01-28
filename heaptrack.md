# heaptrack

Install and attach heaptrack to pid 29

```
apt-get update
apt-get install heaptrack gdb -y
heaptrack -p 29

heaptrack output will be written to "/app/heaptrack.gunicorn.3707.gz"
injecting heaptrack into application via GDB, this might take some time...
injection finished

^C
```

Press ^C to exit and heaptrack will keep running in the background. To stop heaptrack `pkill heaptrack`

Convert heaptrack to flame-graph compatible stack file stacks.txt:

```
heaptrack_print -f heaptrack.gunicorn.32024.prod.gz -F heaptrack.gunicorn.prod.stacks.txt
```
