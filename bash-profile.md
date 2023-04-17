<div title="bash profile" creator="YourName" modifier="YourName" created="201208252222" modified="201208252223" tags="bash linux" changecount="2">
<pre>!Adding ~/bin to path

add the following to the end of .bashrc

{{{
# set PATH so it includes user's private bin if it exists
if [ -d &quot;$HOME/bin&quot; ] ; then
    PATH=&quot;$HOME/bin:$PATH&quot;
fi
}}}

NB: I tried this in .profile and .bash_profile but those files weren't being executed on Xbuntu.

http://askubuntu.com/questions/60218/how-to-add-a-directory-to-my-path
http://mywiki.wooledge.org/DotFiles
http://superuser.com/questions/253250/why-is-shell-not-reading-from-bash-startup-files</pre>
</div>
