# pyenv

## Why?

pyenv builds python from source using its [python-build](https://github.com/pyenv/pyenv/tree/master/plugins/python-build) plugin. You can install a specific minor version rather than whatever your package manager (eg: brew) gives you. It also, unlike most package managers, allows you to have multiple versions of python installed and switch between them. It works the same across platforms (eg: macOS, ubuntu, redhat) which allows you to maintain a consistent python version when system python distributions differ. Also, by having your applications depend on a pyenv controlled version of python, when the package manager upgrades python it doesn't force the change on your existing virtualenvs.

## Install

- Install binaries on Mac OS X: `brew install pyenv`
- Install binaries and [all plugins](https://github.com/pyenv/pyenv-installer/blob/master/bin/pyenv-installer#L69) on \*nix using [pyenv-installer](https://github.com/pyenv/pyenv-installer): `curl https://pyenv.run | bash`

Bash config:

```shell
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile
```

Zsh config:

```shell
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
```

`eval "$(pyenv init -)"` adds _~/.pyenv/shims_ to the path, which are shims for `python`. For more info see [here](https://github.com/pyenv/pyenv#advanced-configuration)

## Usage

Before installing a version of python, which is built from source, make sure your system has the [suggested build environment](https://github.com/pyenv/pyenv/wiki#suggested-build-environment) otherwise the build may produce warnings.

`pyenv install -l` list the versions of python available for install from the [definition set](https://github.com/pyenv/pyenv/tree/master/plugins/python-build/share/python-build). Includes pypy and anaconda.  
`pyenv install -v 3.6.2` install version 3.6.2 to _~/.pyenv/versions/3.6.2/_ in verbose mode (outputs compilation status to stdout)  
`pyenv versions` show all python versions available. _system_ = whatever version would run if pyenv weren't installed.  
`pyenv global` show/set the python version for this user, as defined in _\$(pyenv root)/version_. If this file is not present, then the _system_ version will be used.  
`pyenv shell` show/set the python version for this shell session, ie: shows/sets the _PYENV_VERSION_ environment variable.  
`pyenv local` show/set the python version for this directory, ie: the _.python-version_ file in the current directory.
`pyenv which <executable>` look for `<executable>` on the PATH.

More info about [choosing the python version](https://github.com/pyenv/pyenv#choosing-the-python-version)

## Python builds

By default pyenv does not build with profile guided optimizations. To do so (which increases build time):

```
CONFIGURE_OPTS=--enable-optimizations pyenv install 3.6.1
```

On Ubuntu use `CONFIGURE_OPTS=--enable-shared` to build a shared library that can be used for embedding python and avoid [#917](https://github.com/pyenv/pyenv/issues/917). This will also [set the RPATH](https://github.com/pyenv/pyenv/issues/65#issuecomment-30998608) so LD_LIBRARY_PATH doesn't need to be updated. See [python-build.md](python-build.md#shared-library) for more info.

For more info on RPATH see:

- [Building Portable Binaries](https://developer.squareup.com/blog/building-portable-binaries/)
- [setting RPATH for python not working](https://stackoverflow.com/questions/43616505/setting-rpath-for-python-not-working)

## pyenv-virtualenv

[pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) is a plugin that extends pyenv to creating and managing virtualenvs. Virtualenvs are recognised like any other pyenv version. This plugin also provides a `pyenv activate` command that works with virtualenvs.

`pyenv virtualenvs` list virtualenvs  
`pyenv virtualenv 3.6.2 general` create a virtualenv called _general_ with python version _3.6.2_. Will fail if this version is not already installed. The virtualenv will be created in _\$(pyenv root)/versions/3.6.2/envs_. It will be symlinked from _\$(pyenv root)/versions/general_ and become a pyenv version that can be used like any other version.

[Auto-activation](https://github.com/pyenv/pyenv-virtualenv#activate-virtualenv) will automatically activate/deactive virtualenvs when entering a directory containing a _.python-version_ file that specifies a valid virtualenv. To enable auto-activation (optional - not needed) add the following to _~/.bashrc_ or _~/.zshrc_

```bash
eval "$(pyenv virtualenv-init -)"
```

## pyenv-virtualenvwrapper (recommended)

[virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/) makes it easy to manage virtualenvs created in `~/.virtualenv`.[pyenv-virtualenvwrapper](https://github.com/pyenv/pyenv-virtualenvwrapper) causes virtualenvwrapper to use the active pyenv version of python when creating a virtualenv, rather than the system version. It places virtualenvs in the standard location, eg: _~/.virtualenvs_ which means it integrates with other tools (unlike pyenv-virtualenv). Tab completion is provided when using its commands.

eg:

```shell
# install the pyenv aware mkvirtualenv bash function
pyenv virtualenvwrapper

# create virtualenv in ~/.virtualenvs/ using the active version of python
mkvirtualenv newenv

# leave
deactivate

# enter/switch virtualenv
workon newenv

# list contents of virtual env dir
ls "$VIRTUAL_ENV"

# list virtual env packages
lssitepackages

# remove all packages
wipeenv

# make a temporary environment. It will be deleted when deactivated
mktmpenv

# show all commands
virtualenvwrapper
```

On first run, `pyenv virtualenvwrapper` will pip install virtualenvwrapper into the currently active python site-packages and virtualenvwrapper.sh into the bin dir. Foy virtualenvwrapper to work in across python versions you need virtualenvwrapper.sh on the path. The virtualenvwrapper module does not need to be installed in each python version.

## zsh plugin for pyenv + pyenv-virtualwrapper

See [tekumara/zsh-pyenv-virtualenvwrapper-lazy](https://github.com/tekumara/zsh-pyenv-virtualenvwrapper-lazy) for lazily loading pyenv-virtualwrapper

## Troubleshooting

To enable `set -x` run with `PYENV_DEBUG=1`.

> ImportError: cannot import name 'main'

eg:

```shell
$ pip --version
Traceback (most recent call last):
  File "~/.pyenv/versions/3.6.5/bin/pip", line 7, in <module>
    from pip import main
ImportError: cannot import name 'main'
```

To fix (re)install the pypi version of pip: `python -m pip install --force-reinstall --user pip`. [ref](https://github.com/pyenv/pyenv/issues/1141)

pip will be installed into `~/.local/lib/pythonX/site-packages/pip`

If the above problem is with pip3, install as follows: `python3 -m pip install --force-reinstall --user pip`

> Failed to initialize virtualenvwrapper.
>
> Perhaps pyenv-virtualenvwrapper has not been loaded into your shell properly.  
> Please restart current shell and try again.

Make sure `eval "$(pyenv init -)"` has been run first.

> /Users/tekumara/.pyenv/shims/python: line 21: /usr/local/Cellar/pyenv/1.2.15/libexec/pyenv: No such file or directory

This can occur when upgrading to a new version of pyenv. To fix, rebuild the shims with `pyenv rehash`

> /usr/local/bin/python: Error while finding module specification for 'virtualenvwrapper.hook_loader' (ModuleNotFoundError: No module named 'virtualenvwrapper')

This can occur when the virtualenvwrapper pip package has not been installed into the right version of python.

eg: in the above example, `/usr/local/bin/python` is the version running, but `pip list` shows it doesn't have `virtualenvwrapper` installed.

> virtualenvwrapper_load:source:3: no such file or directory: /home/compute/.local/bin/virtualenvwrapper.sh

Check VIRTUALENVWRAPPER_SCRIPT is correctly set

> pyenv-virtualenvwrapper: system: either virtualenvwrapper.sh or virtualenvwrapper_lazy.sh is not available.

_virtualenwrapper.sh_ [can't be found](https://github.com/pyenv/pyenv-virtualenvwrapper/blob/2c23eb3/bin/pyenv-virtualenvwrapper#L27) in the pyenv version's site-packages script dir, or on the PATH using `pyenv which virtualenvwrapper.sh`, even after attempts to install it via `pip install virtualenvwrapper`.

Your site-packages executable script dir is:

- _~/.local/bin_ when using the Ubuntu system python version. If you are using the pyenv `system` version make sure this directory is on your PATH.
- "$(pyenv prefix $(pyenv version-name))/bin" when using a pyenv version of python, eg: _/.pyenv/versions/3.11.1/bin/virtualenvwrapper.sh_

On macOS, virtualenvwrapper may have been installed into xcode's _~/Library/Python/3.9/bin/_ which is not on the PATH. Uninstall it and re-install it into your pyenv version, eg:

```
PIP_REQUIRE_VIRTUALENV=false /usr/bin/pip3 uninstall virtualenvwrapper     # xcode
PIP_REQUIRE_VIRTUALENV=false pip install virtualenvwrapper                 # pyenv version
```

> pyenv-virtualenvwrapper: 3.9: virtualenv-clone is not available.

This is the same class of error as the previous one above, ie: _virtualenv-clone_ [can't be found](https://github.com/pyenv/pyenv-virtualenvwrapper/blob/2c23eb3/bin/pyenv-virtualenvwrapper#L47) in the pyenv version's site-packages script dir, or on the PATH using `pyenv which virtualenv-clone`.

On macOS, virtualenv-clone may have been installed into xcode's _~/Library/Python/3.9/bin/_ which is not on the PATH. Uninstall it and re-install it using brew python, eg:

```
PIP_REQUIRE_VIRTUALENV=false /usr/bin/pip3 uninstall virtualenv-clone           # xcode
PIP_REQUIRE_VIRTUALENV=false pip install virtualenv-clone                       # pyenv version
```

> ModuleNotFoundError: No module named 'pip'

eg:

```
Traceback (most recent call last):
  File "/home/compute/.pyenv/versions/3.10/bin/pip", line 5, in <module>
    from pip._internal.cli.main import main
ModuleNotFoundError: No module named 'pip'
```

The `pip` module isn't present on `sys.path`.

> pyenv-virtualenvwrapper: system: python is not available.

pyenv-virtualenvwrapper expects `python` to be on the path, has it been installed? If using ubuntu, the [python-is-python3](https://launchpad.net/ubuntu/focal/+package/python-is-python3) package can be used to symlink python -> python3.

> pyenv: virtualenv: command not found

Install virtualenv:

```
PIP_REQUIRE_VIRTUALENV=false pip install --force-reinstall virtualenv
```
