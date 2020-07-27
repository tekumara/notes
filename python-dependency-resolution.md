# python dependency resolution

pip lacks a dependency resolver, and so unable to resolve incompatibility issues which surface as:

```
ERROR: my-app 1.0.0 has requirement Flask~=1.0.2, but you'll have flask 1.1.2 which is incompatible.
```

Even more harmful is when transitive dependencies drift in an incompatible way, causing future builds of the the app to fail (this has happened!)

Adding a resolver to pip is tracked in [pypa/pip#988](https://github.com/pypa/pip/issues/988).

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

## pipenv

pipenv, like poetry, offers virtualenv management with dependency resolution, replacing pip and setuptools. It uses a [patched version](https://github.com/jazzband/pip-tools/issues/679#issuecomment-418268361) of pip-tools. So like pip-compile it can't resolve `pipenv install oslo.utils==1.4.0` and [other cases](https://github.com/pypa/pipenv/labels/Category%3A%20Dependency%20Resolution).

## pipgrip

[pipgrip](https://github.com/ddelange/pipgrip) vendors the [sdispater/mixology](https://github.com/sdispater/mixology) implementation of PubGrub for resolution. Works with `pip` and a requirements file.

Slower than poetry, but like poetry can resolve [cases](https://github.com/jazzband/pip-tools/issues/1187) pip-compile can't.

## dephell

[dephell](https://github.com/dephell/dephell) .... TODO

## performance

* pip-compile 6 sec
* poety 11 sec
* pipgrep 30 sec
