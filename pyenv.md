# pyenv

## Why?

pyenv builds python from source using its [python-build](https://github.com/pyenv/pyenv/tree/master/plugins/python-build) plugin. This allows you to install a specific minor version rather than whatever your package manager (eg: brew) gives you. It also, unlike most package managers, allows you to have multiple versions of python installed and switch between them. It works the same across platforms (eg: macOS, ubuntu, redhat) which allows you to maintain a consistent python version when system python distributions differ. Also, by having your applications depend on a pyenv controlled version of python, when the package manager upgrades python it doesn't force the change on your applications.

##  Install

* Install binaries on Mac OS X: ```brew install pyenv```
* Install binaries on *nix using [pyenv-installer](https://github.com/pyenv/pyenv-installer): ```curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash```
* bash: 
```
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile
```
* zsh:
```
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
```

What ```eval "$(pyenv init -)"``` does is add *~/.pyenv/shims* to the path, and adds a wrapper around pyenv. For more info see [here](https://github.com/pyenv/pyenv#advanced-configuration)

## Usage

Before installing a version of python, which is built from source, make sure your system has the [suggested build environment](https://github.com/pyenv/pyenv/wiki#suggested-build-environment) otherwise the build may produce warnings.

```pyenv install -l``` list the versions of python available for install from the [definition set](https://github.com/pyenv/pyenv/tree/master/plugins/python-build/share/python-build). Includes pypy and anaconda.  
```pyenv install -v 3.6.2``` install version 3.6.2 to *~/.pyenv/versions/3.6.2/* in verbose mode (outputs compilation status to stdout)  
```pyenv versions``` show all python versions available. *system* =  whatever version would run if pyenv weren't installed.  
```pyenv global``` show/set the python version for this user, as defined in *$(pyenv root)/version*. If this file is not present, then the *system* version will be used.  
```pyenv shell``` show/set the python version for this shell session, ie: shows/sets the *PYENV_VERSION* environment variable.  
```pyenv local``` show/set the python version for this directory, ie: the *.python-version* file in the current directory.

More info about [choosing the python version](https://github.com/pyenv/pyenv#choosing-the-python-version)

## pyenv-virtualenv

[pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) is a plugin that extends pyenv to creating and managing virtualenvs. Virtualenvs are recognised like any other pyenv version. This plugin also provides a ```pyenv activate``` command that works with virtualenvs.

```pyenv virtualenvs``` list virtualenvs  
```pyenv virtualenv 3.6.2 general``` create a virtualenv called *general* with python version *3.6.2*. Will fail if this version is not already installed. The virtualenv will be created in *$(pyenv root)/versions/3.6.2/envs*. It will be symlinked from *$(pyenv root)/versions/general* and become a pyenv version that can be used like any other version.  

[Auto-activation](https://github.com/pyenv/pyenv-virtualenv#activate-virtualenv) will automatically activate/deactive virtualenvs when entering a directory containing a *.python-version* file that specifies a valid virtualenv. To enable auto-activation (optional - not needed) add the following to *~/.bashrc* or *~/.zshrc*
```
eval "$(pyenv virtualenv-init -)"
```

## pyenv-virtualenvwrapper (recommended)

[pyenv-virtualenvwrapper](https://github.com/pyenv/pyenv-virtualenvwrapper) causes virtualenvwrapper to use the active pyenv version of python when creating a virtualenv, rather than the system version. It places virtualenvs in the standard location, eg: *~/.virtualenvs* which means it integrates with other tools (unlike pyenv-virtualenv). Tab completion is provided when using its commands.

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

# list contents of virtual env site-packages dir 
ls "$VIRTUAL_ENV"/lib/python*/site-packages 

# remove all packages
wipeenv

```

Install the [lazy version](https://virtualenvwrapper.readthedocs.io/en/latest/install.html?highlight=lazy#lazy-loading) into your .bashrc, for a quicker shell startup time:
```
pyenv virtualenvwrapper_lazy
```

## zsh plugin for pyenv + pyenv-virtualwrapper

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