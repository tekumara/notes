<div title="Grep" modifier="YourName" created="201011150826" modified="201711060304" tags="linux grep" changecount="20">
<pre>Show more context, ie: 5 lines before and 5 lines after the match
{{{
grep -5 foo /tmp/bar.txt
}}}

Count number of occurrences of the tag ToiletDetails (including multiple occurrences per line)
{{{
grep -o \&lt;ToiletDetails ./src/main/resources/toilets.xml | wc -l
}}}

Search all files and subdirectories (-r) of current directory for case insensitive (-i) pattern {{{boo}}}.
{{{
$ grep -ir boo .
}}}

Multiple patterns means OR, eg: to search for foo or bar in a line:
{{{
grep -e foo -e bar /tmp/my.log
}}}

Search all files and subdirectories (-r) of current directory that have the filename pattern &quot;*.tsv&quot; for case insensitive (-i) pattern {{{boo}}}.
{{{
grep -r --include &quot;*.tsv&quot; bar .
}}}

Return value of a key/value pair:
{{{
grep -oP 'key=\K(.*)' config.properties
}}}

The \K is the short-form (and more efficient form) of (?&lt;=pattern) which you use as a zero-width look-behind assertion before the text you want to output. The look-behind part (ie: key=) won't be output, but anything after it will be, even if outside the capture group.

Capture text in a tag:
{{{
echo &quot;&lt;value&gt;foo&lt;/value&gt;&quot; | grep -oP &quot;&lt;value&gt;\K.*?(?=&lt;/value&gt;)&quot;
}}}

grep -P is perl syntax and is needed to support things like the non-greedy operator {{{?}}} or {{{\K}}}.
grep -o only prints the match (not just capture group, for that use perl), each match per line.

Not matching text:
{{{
grep -v ERROR
}}}
Multiple negative matches, ie: lines without ERROR or WARN
{{{
grep -v -e ERROR -e WARN
}}}


!Searching on Mac OS file return all lines

The can happen if the file has old Mac style line breaks (CR only), as opposed to unix line breaks (LF only). 

Mac line breaks are indicated by a single ^M (carriage return, 0xd) in Vim, or try {{{file filename}}} and you will see something like {{{E-MTAB-1733.tsv: ASCII text, with CR line terminators}}}

To fix, see [[Fix Mac Line Ends]]</pre>
</div>
