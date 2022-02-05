<div title="Find" creator="YourName" modifier="YourName" created="201810130853" modified="201810130854" changecount="3">
<pre>!Find files

{{{find . -iname 'kdeb*'}}}

Find any file in this dir or its subdirs that matches 'kdeb*'. NB: wildcard is required and quotes should be used to prevent shell from expanding them.

To discard all erorrs:

{{{find . -iname 'kdeb*' 2&gt;/dev/null}}}

!Execute command on all files in a directory

eg:
{{{find . -type f -exec python ~/hackday/scripts/soup.py {} \;}}}</pre>
</div>
