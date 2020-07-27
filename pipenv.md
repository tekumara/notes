# Pipenv

Why?
* Official python.org packaging tool - NB: this is [disputed](https://chriswarrick.com/blog/2018/07/17/pipenv-promises-a-lot-delivers-very-little/#officially-recommended-tool-or-how-we-got-here).
* Provides mechanisms for keeping dependencies fresh (by storing package name only in `Pipfile`), rather than pinning every version like `pip freeze > requirements.txt`, while maintaining reproducible builds via `Pipfile.lock`. Upgrade dependencies to the latest with `pipenv update`
* Can generate a dependency graph with `pipenv graph`
* Automatically creates virtualenvs in one place under `~/.local/share/virtualenvs/`
* Combines `pip`, `virtualenv` and dependency specification (ie: `Pipfile` which replaces `requirements.txt`) into one tool
* Adds/removes packages from `Pipfile` as you install/uninstall packages
* Single `Pipfile` for dev, and prod dependencies.
* Run commands inside the virtualenv without having to activate it via `pipenv run <cmd>`, alternatively start a shell in the virtualenv with `pipenv shell`

Install [pipenv](http://docs.python-guide.org/en/latest/dev/virtualenvs/):
* Mac OS X `brew install pipenv`
* Linux

```
pip3 install --user pipenv
# add to path in .zshrc, if it doesn't already exist
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"
```

* Bleeding edge `pip3 install git+https://github.com/pypa/pipenv.git#egg=pipenv`

Usage
|| |
|--|--|
|`pipenv install`|Includes 1) editing the Pipfile to add new dependencies (or creating a new one if it doesn't exist - optionally from a requirements.txt if present), 2) detecting differences between the Pipfile and Pipfile.lock (eg: `Pipfile.lock (b5c0bd) out of date, updating to (a44910)…`) and updating it, ie: `pipenv lock`, and 3) installing depedencies into the virtualenv (creating it if it doesn't exist), ie: `pipenv sync`. NB: when adding a new file pipenv resolves and reinstalls the whole environment see [#1219](https://github.com/pypa/pipenv/issues/1219) |
|`pipenv install --deploy`|Will only install if there have been no changes to the Pipfile (ie: the Pipfile hash matches what is stored in Pipfile.lock). If there have been changes then the install will abort with `Your Pipfile.lock (625274) is out of date. Expected: (e5f27f).`. If there is no Pipfile.lock, it will create an one (from the Pipfile, or if there's no Pipfile it will create an empty Pipfile first). |
|`pipenv install ----ignore-pipfile`|Ignore any recent changes to the Pipfile and install dependency versions as per Pipfile.lock. Do not update Pipfile.lock|
|`pipenv update`|Update all unpinned dependecies to their latest version|
|`pipenv install --selective-upgrade X`| selectively upgrade only things that are dependencies of the new package, doesn't really work, see [#1554](https://github.com/pypa/pipenv/issues/1554) and [#966](https://github.com/pypa/pipenv/issues/966)|
|`pipenv install --skip-lock X`|Add package X to the Pipfile, and install it into the virtua|env, but don't update Pipfile.lock|
|`pipenv graph`|show graph of installed dependencies, ie: what's in the virtualenv, not the Pipfile or Pipfile.lock|
|`pipenv run pip list`|show all installed packages and their version|
|`pipenv --venv`|show the virtualenv path|
|`pipenv lock`|Create/update Pipfile.lock from the Pipfile. The Pipfile.lock declares all dependencies (and sub-dependencies) of your project, their version, and the current hashes for files downloaded from pypi. Unpinned version dependencies (eg: `*` in the Pipfile) with be resolved to the latest available version when running `pipenv lock`. The virtualenv will not be updated, to do that run `pipenv sync`.|
|`pipenv sync`|Installs all package versions specified in Pipfile.lock, creating a virtualenv is one doesn't exist. Better than `pipenv install --deploy --ignore-pipfile` expect because it will fail if there is no Pipfile.lock. See https://github.com/pypa/pipenv/issues/1463|
|`pipenv --rm`|Removes the virtualenv. Equivalent to `rm -rf `pipenv --venv``|
|`pipenv uninstall --lock X`|Remove package X from the Pipfile and virtualenv but don't update Pipfile.lock.Useful if you want to follow this command with another that will update Pipfile.lock, and you want to avoid re-locking (locking can take some time)|

To install from a git repo, add the package name as an egg argument, eg: `pipenv install git+https://github.com/tukushan/main.git#egg=rmkemker_main`
In the Pipfile, it will look like:

```
rmkemker_main = {git = "https://github.com/tukushan/main.git"}
```

To run pipenv using a Pipfile/virtualenv other than the current directory:

```
PIPENV_PIPFILE=subprojects/spark-dist/Pipfile pipenv run
```

Pipenv will use a Pipfile in the current directory, or its parent, grandparent or great-grandparent directory.

## Pyenv integration

When creating a new virtualenv via `pipenv install`, pipenv will select the python version from pyenv that's specified in the Pipfile. If the appropriate version isn't already installed, then it will use pyenv to download and install the missing CPython version.

If this doesn't work, set `PYENV_ROOT` ([ref](https://github.com/pypa/pipenv/blob/0ec97edbf797d0d3d133dc773831c5e7fab92cd2/docs/diagnose.rst#-my-pyenv-installed-python-is-not-found)):

```
export PYENV_ROOT=$HOME/.pyenv
```

pyenv will build and install the appropriate python version under `~/.pyenv/versions/`. The virtualenv will be created in the usual place (ie: under `~/.local/share/virtualenvs/`) with binaries etc. from the newly installed version of python.

## Limitations

* Stability issues - newer versions of pipenv have broken production ([#2924](https://github.com/pypa/pipenv/issues/2924)) or haven't worked locally with pyenv ([#3224](https://github.com/pypa/pipenv/issues/3224)) - which has meant using builds from the head of master to get around issues in new versions.
* `pipenv lock` is much slower than `pip freeze`.
* `pipenv run python ...` is slow because it must run python first to run pipenv, and then spawn a new shell to run python again. This makes it slow for command line apps/scripts/one-liners. Compare this to sourcing a virtualenv, which changes the shell environment to use a specific version of python, which takes neligible time.
* Forces a particular workflow, which uses the current directory to select the virtualenv
* The dependency solver doesn't work in some cases and requires debugging, eg: see [#2812](https://github.com/pypa/pipenv/issues/2812). `pip` seems to more reliably work, even though it can't resolve conflicts.
* `Pipfile.lock` doesn't work reliably between Mac and Linux - eg: on one occasion the hashes generated on Mac didn't include the Linux version of the package, another time a particular version of a package was missing on the other OS (probably more the package maintainers fault)
* Selectively updating a package doesn't work - you have to update everything or nothing.

See:
* [Pipenv review, after using it in production](https://medium.com/@DJetelina/pipenv-review-after-using-in-production-a05e7176f3f0)
* [Pipenv: promises a lot, delivers very little](https://chriswarrick.com/blog/2018/07/17/pipenv-promises-a-lot-delivers-very-little/)

# Pipenv Issues

## Errors

```
[pipenv.exceptions.InstallError]: ['THESE PACKAGES DO NOT MATCH THE HASHES FROM THE REQUIREMENTS FILE. If you have updated the package versions, please update the hashes. Otherwise, examine the package contents carefully; someone may have tampered with them.', '    importlib-resources==1.0.1 from https://files.pythonhosted.org/packages/81/a3/466b268701207e00b4440803be132e892bd9fc74f1fe786d7e33146ad2c7/importlib_resources-1.0.1-py2.py3-none-any.whl#sha256=87684c76eca1c1b76012a6771be451b2aadc549dbe2725d17ab6398d39878a33 (from -r /tmp/pipenv-611gchfp-requirements/pipenv-eof01reh-requirement.txt (line 1)):', '        Expected sha256 73f454e062ac149bafd262b18c1f9ebc91f53bd6474e028d1bf1c59ebd152efb', '             Got        87684c76eca1c1b76012a6771be451b2aadc549dbe2725d17ab6398d39878a33']
```

Manually add the hash to `Pipfile.lock`

## Pipenv graph

If pipenv graph is empty trying updating to version 2018.05.18: `pip install --upgrade pipenv --user`
Pipenv graph walks the installed dependencies, so if you have a lock file but not virtualenv, sync first.
If you have a cyclic dependency, it may not show in pipenv graph. Try [pipdeptree](https://github.com/naiquevin/pipdeptree) instead. It needs to be installed inside and run within the virtualenv.

## Resolution errors

```
$ pipenv lock
Warning: Your dependencies could not be resolved. You likely have a mismatch in your sub-dependencies.
  You can use $ pipenv install --skip-lock to bypass this mechanism, then run $ pipenv graph to inspect the situation.
  Hint: try $ pipenv lock --pre if it is a pre-release dependency.
Could not find a version that matches keras-applications==1.0.2,==1.0.4 (from -r /tmp/pipenv-6meh1cd0-requirements/pipenv-cwe57wbz-constraints.txt (line 6))
Tried: 1.0.0, 1.0.0, 1.0.1, 1.0.1, 1.0.2, 1.0.2, 1.0.4, 1.0.4
There are incompatible versions in the resolved dependencies.
```

Tried clearing the cache `pipenv lock --clear` but didn't help. Ended up generating the lock file on a different machine. `pipdeptree` shows a cyclic dependency:
```
Warning!! Cyclic dependencies found:
* Keras => keras-applications => Keras
* Keras => keras-preprocessing => Keras
* Keras-Preprocessing => keras => Keras-Preprocessing
* Keras-Applications => keras => Keras-Applications
```

```
$ pipenv lock
Warning: Your dependencies could not be resolved. You likely have a mismatch in your sub-dependencies.
  You can use $ pipenv install --skip-lock to bypass this mechanism, then run $ pipenv graph to inspect the situation.
  Hint: try $ pipenv lock --pre if it is a pre-release dependency.
Could not find a version that matches urllib3<1.23,<1.24,==1.23,>=1.20,>=1.21.1
Tried: 0.3, 1.0, 1.0.1, 1.0.2, 1.1, 1.2, 1.2.1, 1.2.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.7.1, 1.8, 1.8.2, 1.8.3, 1.9, 1.9.1, 1.9.1, 1.10, 1.10, 1.10.1, 1.10.1, 1.10.2, 1.10.2, 1.10.3, 1.10.3, 1.10.4, 1.10.4, 1.11, 1.11, 1.12, 1.12, 1.13, 1.13, 1.13.1, 1.13.1, 1.14, 1.14, 1.15, 1.15, 1.15.1, 1.15.1, 1.16, 1.16, 1.17, 1.17, 1.18, 1.18, 1.18.1, 1.18.1, 1.19, 1.19, 1.19.1, 1.19.1, 1.20, 1.20, 1.21, 1.21, 1.21.1, 1.21.1, 1.22, 1.22, 1.23, 1.23
There are incompatible versions in the resolved dependencies.
```

In this case, giving the resolver an explicit version of the failling transitive dependency (urllib3) helps it find a version that satisfies the constraints. See [#2812](https://github.com/pypa/pipenv/issues/2812)