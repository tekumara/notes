<div title="Fix Mac Line Ends" creator="YourName" modifier="YourName" created="201411251605" modified="201411251606" tags="Lineends Mac" changecount="2">
<pre>Mac line breaks are indicated by a single ^M (carriage return, 0xd) in Vim, or try {{{file filename}}} and you will see something like {{{E-MTAB-1733.tsv: ASCII text, with CR line terminators}}}

To fix:

{{{
perl -pi -e 's/\r/\n/g' filename
}}}

Or in Vim, see here: http://stackoverflow.com/questions/811193/how-to-convert-the-m-linebreak-to-normal-linebreak-in-a-file-opened-in-vim/811208#811208</pre>
</div>
