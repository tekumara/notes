<div title="Netcat" creator="YourName" modifier="YourName" created="201406231220" tags="netcat" changecount="1">
<pre>!Copy a file

Start a netcat listening on the source:
{{{nc -l &lt;port&gt; &lt; myfile}}}

Receive it on the destination:
{{{nc &lt;host&gt; &lt;port&gt; &gt; myfile}}}

Or, if client is linux without netcat installed:
{{{cat &lt; /dev/tcp/&lt;ip&gt;/&lt;port&gt; &gt; myfile}}}

[[Ref|http://unix.stackexchange.com/questions/49936/dev-tcp-listen-instead-of-nc-listen]]</pre>
</div>
