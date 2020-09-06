# Virtualenv

Virtualenvs enable you to separate project dependencies from other projects, and from the OS distribution version of python.

## virtualenv

To install the virtualenv package and the `/usr/local/bin/virtualenv` wrapper script

```
pip3 install virtualenv
```

To create a virtual venv in `.venv`, using `/usr/bin/python3` if it exists, otherwise `/usr/bin/python`

```
virtualenv .venv
```

The virtualenv will contain the latest versions of pip, setuptools, and wheel.

To setup a virtual env to use python3.6:

```
virtualenv --python=/usr/bin/python3.6 .venv
```

To enter a virtualenv

```
. /path/to/.venv/bin/activate
```

To leave

```
deactivate
```

## venv

As of Python 3.3 the [venv module](https://docs.python.org/3/library/venv.html) allows you to create virtualenvs.

eg: create a virtualenv in `.venv`

```
python3 -m venv .venv
```

The virtualenv will contain outdated versions of pip, setuptools, and **not wheel**. You may want to update them. See [#30628 why venv install old pip?](https://bugs.python.org/issue30628)

On Debian/Ubuntu requires ensurepip, installed via `apt-get install python3-venv`

## pyvenv

As of python 3.6, the pyvenv script is deprecated in favour of `python3 -m venv` (see [python 3.6 release notes](https://docs.python.org/dev/whatsnew/3.6.html#id8))

## virtualenvwrapper

[virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/index.html) is a shell script that creates virtualenvs in a single place, and provides commands to list the packages installed and switch between virtualenvs.
eg:

```
mkvirtualenv <project>
workon <project>
pip install -r requirements.txt
```

## pew

[pew](https://github.com/berdario/pew) is a pure python virtualenv manager. Like pipenv it creates virtualenvs in `~/.local/share/virtualenvs`.

To start a new shell in a venv

```
pew workon my_env
```

To run a script in a venv

```
pew in my_env my_script.py
```

[Use pew, not virtualenvwrapper, for Python virtualenvs](https://planspace.org/20150120-use_pew_not_virtualenvwrapper_for_python_virtualenvs/) if you want a subshell. But, it's also slower than the bash equivalent.
