# python dependency resolution

Projects typically express dependencies in the "abstract", ie: as version ranges, and without transitive dependencies. This is common and useful for libraries which need to be flexible so they will work in a range of applications.

Applications however can suffer from transitive dependencies breaking if they don't follow semver correctly, or introduce new bugs when upgrading within version ranges. In order for an application to be built in a reproducible way, it will want to pin all dependencies, including transitive dependencies, to specific versions via a lock file.

## PEP 665

[PEP 665](https://peps.python.org/pep-0665/) defined a way to represent an exhaustive list of all dependencies (aka lock files) but was rejected in part and [not feasible for Poetry](https://twitter.com/SDisPater/status/1521932870918492163?s=20&t=C5NO9wfdKsJlsDug9e7DXw).

## pip

pip historically lacked a dependency resolver, and so was unable to resolve incompatibility issues which surface as:

```
ERROR: my-app 1.0.0 has requirement Flask~=1.0.2, but you'll have flask 1.1.2 which is incompatible.
```

pip 20.3 introduced a dependency resolver see [pypa/pip#988](https://github.com/pypa/pip/issues/988). In some cases it's slow and needs to download multiple versions of a package in order to find one satisfying constraints, eg:

```
Collecting boto3>=1.20.0
  Using cached boto3-1.24.35-py3-none-any.whl (132 kB)
  Using cached boto3-1.24.34-py3-none-any.whl (132 kB)
  Using cached boto3-1.24.33-py3-none-any.whl (132 kB)
  Using cached boto3-1.24.32-py3-none-any.whl (132 kB)
  Using cached boto3-1.24.31-py3-none-any.whl (132 kB)
```

`pip freeze` can be used to generate a lock file, but there's no easy way to go between a list of top level dependencies and the lock file of all files.

## pip-compile

pip-compile will resolve packages for the same Python version and OS it is running on. This is most likely to be fine because you probably aren't using [environment markers](https://www.python.org/dev/peps/pep-0508/#environment-markers).

Produces a requirements.txt.

The resolver is faster than poetry, when not using hashes.

`pip-compile --generate-hashes` will generate hashes which takes a lot longer if packages are not already in the cache

Doesn't have a [proper dependency resolver](https://github.com/jazzband/pip-tools/issues/1187#issuecomment-663993125) and fails on resolving `oslo.utils==1.4.0`.

## poetry

[poetry](https://github.com/python-poetry/poetry) offers virtualenv management with dependency resolution, essentially replacing pip and setuptools. This means that poetry packages don't contain `setup.py`, and hence are not compatible with `pip install -e`. Instead dependencies are specified in `pyproject.toml` and resolved to `poetry.lock`. However `poetry export -f requirements.txt` will export resolved dependencies to `requirements.txt`.

poetry is slower than pip-compile but can resolve [cases](https://github.com/jazzband/pip-tools/issues/1187) pip-compile can't.

poetry requires that the version of python is specified. It supports [environment markers](https://python-poetry.org/docs/versions/#using-environment-markers).

Has some pathologically [slow cases](https://github.com/python-poetry/poetry/issues/2094) (eg: `poetry add allennlp` on macOS takes 3mins)

## pipenv

pipenv, like poetry, offers virtualenv management with dependency resolution, replacing pip and setuptools. It uses a [patched version](https://github.com/jazzband/pip-tools/issues/679#issuecomment-418268361) of pip-tools. So like pip-compile it can't resolve `pipenv install oslo.utils==1.4.0` and [other cases](https://github.com/pypa/pipenv/labels/Category%3A%20Dependency%20Resolution).

## pipgrip

[pipgrip](https://github.com/ddelange/pipgrip) vendors the [sdispater/mixology](https://github.com/sdispater/mixology) implementation of PubGrub for resolution. Works with `pip` and a requirements file.

Slower than poetry, but like poetry can resolve [cases](https://github.com/jazzband/pip-tools/issues/1187) pip-compile can't.

## dephell

[dephell](https://github.com/dephell/dephell) .... TODO

## performance

- pip-compile 6 sec
- poety 11 sec
- pipgrep 30 sec

allennlp

- poetry 5m 28s (1m 50s second run)
- pipgrip 2m 37s
