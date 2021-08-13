<div title="Sed" creator="YourName" modifier="YourName" created="201412081301" modified="201812160026" tags="sed" changecount="15">
<pre>Insert line before line with &quot;config.vm.provider&quot;. Do inplace (ie: overwriting Vagrantfile)
{{{
sed -i &quot;&quot; -e '/config.vm.provider/ i\'$'\n''  config.vm.network :forwarded_port, guest: 8983, host: 8983' Vagrantfile
}}}

Replace the value of the variable ~SOLR_LOG with /solr/solr/logs
{{{
sed -i 's/SOLR_LOG=.*/SOLR_LOG=\/solr\/solr\/logs' solr.sh
}}}

Replace BASE= using a variable substitution ($~MONGO_HOME), note the following:
* use of double quotes so that substitution is performed
* use of | as a delimiter instead of slash, because $~MONGO_HOME contains slashes
{{{
sed -i &quot;s|BASE=.*|BASE=$MONGO_HOME|&quot; /etc/init.d/mongodb
}}}

!Special characters

eg: given the line:

{{{if [[ $* =~ &quot;newrelic&quot; ]] &amp;&amp; [[ -f &quot;${NAGIOS_HOME}/.newrelic_enable&quot; ]]}}}

and you want to remove {{{[[ $* =~ &quot;newrelic&quot; ]] &amp;&amp; }}}

{{{sed -i 's|\[\[ \$\* =~ &quot;newrelic&quot; \]\] \&amp;\&amp; ||' ./bin/tomcat_ctl.sh}}}

see [[What characters do I need to escape when using sed in a sh script?|http://unix.stackexchange.com/questions/32907/what-characters-do-i-need-to-escape-when-using-sed-in-a-sh-script]]

!Delete line

To delete the whole line that contains the phrase 'newrelic is optional':
{{{
sed -i '/newrelic is optional/d' ./bin/tomcat_ctl.sh
}}}

!Sed on Mac OS X

On Mac OS X sed doesn't support so-called enhanced patterns such as \s, \b, \d. Prefer perl instead. [[ref|http://stackoverflow.com/questions/12178924/os-x-sed-e-doesnt-accept-extended-regular-expressions]]

{{{invalid command code o}}}: make sure you provide a file extension to -i, eg: {{{sed -i.bak ...}}} or {{{sed -i ''}}} to replace without backing up (note on GNU/linux this would be {{{sed -i''}}} ie: no space after the flag).

!Multiple replacements

Multiple replacements can be strung together with a semicolon, eg:
{{{
sed 's/^/&quot;/;s/,text/&quot;,text/'
}}}

!Prefix with newline

{{{echo hello | sed -e 's/^/\\n/'}}} produces {{{\nhello}}}

{{{echo hello | sed -e $'s/^/\\\n/'}}} works correctly. The {{{$'....'}}} contains a string literal in which bash performs C-style backslash substitution, e.g. {{{$'\n'}}} is translated to an actual newline. The {{{\\}}} is needed to produce a {{{\}}} which is required by sed in front of an acutal newline. [[ref|https://stackoverflow.com/a/11163357/149412]]</pre>
</div>
