<div title="ps" creator="YourName" modifier="YourName" created="201406131558" modified="201802070227" tags="bash" changecount="11">
<pre>{{{
ps -eo pid,ppid,user,class,rtprio,ni,pri,psr,pcpu,stat,wchan:14,comm,cmd
}}}

To show full listing, with hierarchy, of only your own processes:
{{{
ps -fH  -u `whoami`
}}}

Sort by resident memory usage desc
{{{
ps aux --sort -rss
}}}

For the elastic process, and the header, sorted by resident memory desc
{{{
 ps ux --sort -rss | grep &quot;RSS\|elastic&quot;
}}}

Watch memory on pid 12611, with datetime
{{{
{ ps u | head -n1; while sleep 1; do COLUMNS=120 ps uh -q 12611; done } |  gawk '{ print strftime(&quot;[%Y-%m-%d %H:%M:%S]&quot;), $0 }'
}}}

See also {{{pidstat -r 1}}} which will show a rolling summary of changes to page fault and memory stats by pid

See all child threads in a tree created by PID 4099, collapsing threads with the same name
{{{
pstree 4099
}}}

See all child threads created by PID 4099, individually with their PID
{{{
ps -p 4099
}}}

See parents, and children, of PID 4099, individually with their PID
{{{
ps -s -p 4099
}}}
</pre>
