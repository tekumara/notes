<div title="Diff" modifier="YourName" created="201012070440" modified="201801160046" tags="diff" changecount="10">
<pre>!Diff

Side by side
{{{
diff -y -W $COLUMNS file1 file2
}}}

Side by side ignoring whitespace and showing only changed lines
{{{
diff -y -W  $COLUMNS -w --suppress-common-lines file1 file2
}}}

Try harder
{{{
diff -d
}}}

!Diff and patch

{{{
#create diff file
diff -uN build.xml &quot;build mod.xml&quot; &gt; unified.diff

#apply patch
patch build.xml &lt; unified.diff
}}}

!Colordiff

{{{
sudo apt-get install colordiff
}}}

Replace {{{diff}}} commands with {{{colordiff}}}.

[[Cool ways to Diff two HTTP Requests in your terminal!|https://gist.github.com/Nijikokun/d6606c036d89d3b1574c]]

!Diff within a line/character level diff

{{{vim -d file1 file2}}} or {{{vimdiff file1 file2}}}

Or horizontal

{{{vim -d -o file1 file2}}} or {{{vimdiff -o file1 file2}}}

!Word diff

With colour:

{{{wdiff -w &quot;$(tput bold;tput setaf 1)&quot; -x &quot;$(tput sgr0)&quot; -y &quot;$(tput bold;tput setaf 2)&quot; -z &quot;$(tput sgr0)&quot; file1 file2}}}

[[ref|http://unix.stackexchange.com/a/11144/2680]]

!Diff output of two commands

Use [[process substitution|http://tldp.org/LDP/abs/html/process-sub.html]]
{{{
diff &lt;(grep 24473 base/similar-headings.cosim | sort) &lt;(grep 24473 stopword/similar-headings.cosim | sort)
}}}

!CSV diff

This uses comma as a word seperator in the diff:
{{{
git diff --color-words --word-diff-regex=&quot;[^[:space:],]+&quot; x.csv y.csv
}}}</pre>
</div>
