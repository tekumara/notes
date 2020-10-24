<div title="Python Install" creator="YourName" modifier="YourName" created="201512020652" modified="201805190903" tags="Python" changecount="37">
<pre>!Python 3 (latest) Mac OS X
{{{
brew install python3
pip3 install virtualenv
}}}

!Python 3.6 Ubuntu

Ubuntu 18.04 will make Python 3.6 the default, see [[here|https://wiki.ubuntu.com/Python/Python36Transition]]
Ubuntu 17.10 ships with Python 3.6

Ubuntu 16.04 - 17.04 ships with:
{{{
/usr/bin/python -&gt; python2.7
/usr/bin/python3 -&gt; python3.5
}}}

To install python3.6 on Ubuntu 16.04 - 17.04 (more details [[here|https://askubuntu.com/questions/865554/how-do-i-install-python-3-6-using-apt-get/865644#865644]]):
{{{
sudo apt-get install python3.6 python3.6-dev
}}}

This will create a {{{/usr/bin/python3.6}}} interpreter. However, {{{/usr/bin/python3}}} will still point to {{{python3.5}}}. Python 3.5 is pretty baked into Ubuntu, so don't try and remove it.

Install pip3 and virtualenv:
{{{
sudo apt-get install python3-pip
pip3 install --upgrade pip
sudo pip3 install virtualenv
}}}

Because {{{pip3}}} uses {{{/usr/bin/python3}}} it will install packages into the python3.5 packages directory (to see which python interpreter pip3 is using: {{{pip3 -V}}}). But that's OK because virtualenv can be made to create python 3.6 envs (see below).

Alternatively, use [[Pyenv]]

!Install pip (python 2) on Ubuntu

{{{
sudo apt-get install python-pip
sudo pip install virtualenv
}}}
</pre>
</div>
