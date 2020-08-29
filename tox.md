# tox

tox is an [automation tool](https://tox.readthedocs.io/en/latest/index.html#system-overview) that creates virtualenv, builds distribution packages, and runs commands.

It is roughly equivalent to:

```
python setup.py sdist
python3 -m venv --clear .tox/py
.tox/py/bin/pip install dist/*.tar.gz

# run any user-specified commands
.tox/py/bin/commands
```

## Isolated builds

By default, tox uses the host environment to [build packages](https://tox.readthedocs.io/en/latest/example/package.html) using setuptools. Isolated builds will create distributions using an isolated virtualenv with your custom build tools specified in pyproject.toml according to PEP 517.

To enable isolated builds in tox.ini, and install and use setuptools within it:

```
[tox]
isolated_build=True
```

and pyproject.toml:

```
[build-system]
requires = [ "setuptools >= 41.1.0", "wheel"]
build-backend = "setuptools.build_meta"
```

Instead of running `python setup.py sdist` this will introduce a package step that creates a virtual env and builds the package using the pyproject.toml config:

> .package recreate: /Users/tekumara/code/aec/.tox/.package
> [83338] /Users/tekumara/code/aec/.tox$ /Users/tekumara/.virtualenvs/aec/bin/python3 -m virtualenv --no-download --python /Users/tekumara/.virtualenvs/aec/bin/python3 .package >.package/log/.package-0.log
.package installdeps: setuptools >= 41.1.0, wheel
[83339] /Users/tekumara/code/aec$ /Users/tekumara/code/aec/.tox/.package/bin/python -m pip install 'setuptools >= 41.1.0' wheel >.tox/.package/log/.package-1.log
> write config to /Users/tekumara/code/aec/.tox/.package/.tox-config1 as 'b92f628631c0b4f38b185964d3fdd53e244566151890e7bdda61565b4fb1d62a /Users/tekumara/.virtualenvs/aec/bin/python3\n3.19.0 0 0 0\n00000000000000000000000000000000 setuptools >= 41.1.0\n00000000000000000000000000000000 wheel'
> [83353] /Users/tekumara/code/aec$ /Users/tekumara/code/aec/.tox/.package/bin/python /Users/tekumara/.virtualenvs/aec/lib/python3.7/site-packages/tox/helper/build_requires.py setuptools.build_meta '' >.tox/.package/log/.package-2.log
[83356] /Users/tekumara/code/aec$ /Users/tekumara/code/aec/.tox/.package/bin/python /Users/tekumara/.virtualenvs/aec/lib/python3.7/site-packages/tox/helper/build_isolated.py .tox/dist setuptools.build_meta '' '' >.tox/.package/log/.package-3.log
> package .tmp/package/1/aec-0.4.7.tar.gz links to dist/aec-0.4.7.tar.gz (/Users/tekumara/code/aec/.tox)

This takes ~4 seconds longer than a non-isolated build.

NB: setuptools will run and create a _\*.egg-info/_ directory in your current directory, not the _.tox/.package/_ directory. Same as when setuptools is run without tox. Always delete this directory before building to remove remnants of previous builds, ie: files that have been since deleted (see [setuptools/#2347](https://github.com/pypa/setuptools/issues/2347)).

## Changedir

`python -m` adds the current directory (ie: your source dir) to `sys.path`. To avoid adding source modules to `sys.path`, change the current working directory to _.tox/py/tmp_ before running commands:

```
[testenv]
# change dir to .tox/py/tmp before running commands (doesn't affect packaging)
changedir = {envtmpdir}
commands = python -m pytest
```
