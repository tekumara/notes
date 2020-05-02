# pyenv

##  Install

Install binaries on Mac OS X: ```brew install pyenv``` then
1. bash: 
```
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile
```
2. zsh:
```
if ! grep -sqF "pyenv" ~/.zshenv; then
    touch ~/.zshenv
    echo -e 'if [[ -f /usr/local/bin/pyenv ]]; then\n  eval "$(/usr/local/bin/pyenv init -)"\nfi' >> ~/.zshenv
fi
```


Install binaries on *nix using [pyenv-installer](https://github.com/pyenv/pyenv-installer): ```curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash```

```eval "$(pyenv init -)"``` will add ```~/.pyenv/shims``` to the path and add a wrapper around pyenv, see [here](https://github.com/pyenv/pyenv#advanced-configuration)

## Usage

```pyenv versions``` show all python versions available. ```system``` =  whatever version would run if pyenv weren't installed.  
```pyenv global``` show/set the python version for this user, as defined in ```$(pyenv root)/version```. If this file is not present, then the ```system``` version will be used.  
```pyenv shell``` show/set the python version for this shell session, ie: shows/sets the ```PYENV_VERSION``` environment variable.  
```pyenv local``` show/set the python version for this directory, ie: the ```.python-version``` file in the current directory.

More info about [choosing the python version](https://github.com/pyenv/pyenv#choosing-the-python-version)

pyenv includes the [python-build](https://github.com/pyenv/pyenv/tree/master/plugins/python-build) plugin, which can be also be installed stand-alone. It can be used to build python versions from source. Make sure your system has the [suggested build environment](https://github.com/pyenv/pyenv/wiki#suggested-build-environment) otherwise the build may produce warnings.

```pyenv install -l``` list the versions of python available for install from the [definition set](https://github.com/pyenv/pyenv/tree/master/plugins/python-build/share/python-build). Includes pypy and anaconda.
```pyenv install -v 3.6.2``` install version 3.6.2 to ```~/.pyenv/versions/3.6.2/``` in verbose mode (outputs compilation status to stdout)


## pyenv-virtualenv

[pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) is a plugin for pyenv for creating and managing virtualenvs that are recognised as pyenv versions. This plugin also provides a ```pyenv activate``` command that works with virtualenvs.

```pyenv virtualenvs``` list virtualenvs
```pyenv virtualenv 3.6.2 general``` create a virtualenv called ```general``` with python version ```3.6.2```. Will fail if this version is not already installed. The virtualenv will be created in ```$(pyenv root)/versions/3.6.2/envs```. It will be symlinked from ```$(pyenv root)/versions/general``` and become a pyenv version that can be used like any other version.  

[Auto-activation](https://github.com/pyenv/pyenv-virtualenv#activate-virtualenv) will automatically activate/deactive virtualenvs when entering a directory containing a ```.python-version``` file that specifies a valid virtualenv. To enable auto-activation (optional - not needed) add the following to ```~/.bashrc``` or ```~/.zshrc```
```
eval "$(pyenv virtualenv-init -)"
```

## pyenv-virtualenvwrapper (recommended)

[pyenv-virtualenvwrapper](https://github.com/pyenv/pyenv-virtualenvwrapper), unlike pyenv-virtualenv, does not extend pyenv with the abillity to create virtualenvs as first-class pyenv versions. Instead, when creating a virtualenv, it makes virtualenvwrapper use the active pyenv version of python, rather than the system version. Unlike pyenv-virtualenv it places virtualenvs in the standard location, eg: `~/.virtualenvs` which means it integrates with other tools.  

eg:
```
# install the pyenv aware mkvirtualenv bash function
pyenv virtualenvwrapper

# create virtualenv in ~/.virtualenvs/ using the active version of python
mkvirtualenv newenv

# leave
deactivate

# enter/switch virtualenv
workon newenv
```

Install the [lazy version](https://virtualenvwrapper.readthedocs.io/en/latest/install.html?highlight=lazy#lazy-loading) into your .bashrc, for a quicker shell startup time:
```
pyenv virtualenvwrapper_lazy
```

## zsh pyenv + pyenv-virtualwrapper plugin

see https://github.com/sorin-ionescu/prezto/tree/master/modules/python

## Errors

```
$ pip --version
Traceback (most recent call last):
  File "~/.pyenv/versions/3.6.5/bin/pip", line 7, in <module>
    from pip import main
ImportError: cannot import name 'main'
```

To fix (re)install the pypi version of pip:  ```python -m pip install --force-reinstall --user pip```. [ref](https://github.com/pyenv/pyenv/issues/1141)

pip will be installed into ```~/.local/lib/pythonX/site-packages/pip```

If the above problem is with pip3, install as follows: ```python3 -m pip install --force-reinstall --user pip```


```
Failed to initialize virtualenvwrapper.

Perhaps pyenv-virtualenvwrapper has not been loaded into your shell properly.
Please restart current shell and try again.
```

Make sure `eval "$(pyenv init -)"` has been run first. 


```
/Users/tekumara/.pyenv/shims/python: line 21: /usr/local/Cellar/pyenv/1.2.15/libexec/pyenv: No such file or directory
```
This can occur when upgrading to a new version of pyenv. To fix, rebuild the shims with `pyenv rehash`

## Ref


[pyenv stackoverflow answer](https://askubuntu.com/a/865644/6127)