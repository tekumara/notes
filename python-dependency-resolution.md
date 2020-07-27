# python dependency resolution

pip lacks a dependency resolver, and so unable to resolve incompatibility issues which surface as:
 
```
ERROR: my-app 1.0.0 has requirement Flask~=1.0.2, but you'll have flask 1.1.2 which is incompatible.
```
 
Even more harmful is when transitive dependencies drift in an incompatible way, causes future builds of the the app to fail (this has happened!)

## pip-compile

pip-compile will resolves packages for the same Python version and OS it is running on. Works with `pip` and a requirements file.

The resolver is faster than poetry, if not using hashes.

`pip-compile --generate-hashes` will generate hashes which takes a lot longer if packages are not already in the cache

Doesn't have a [proper dependency resolver](https://github.com/jazzband/pip-tools/issues/1187#issuecomment-663993125).

## poetry

poetry offers package management with dependency resolution, essentially replacing pip and setuptools. This means that poetry packages don't contain `setup.py`, and hence are not compatible with `pip install -e`.

Instead dependencies are specified in `pyproject.toml` and resolved to `poetry.lock`. `poetry export -f requirements.txt` will export resolved dependencies to requirements.txt format.

poetry is slower than pip-compile but can resolve [cases](https://github.com/jazzband/pip-tools/issues/1187) pip-compile can't.

poetry can resolve for specific versions of Python.

## [pipgrip](https://github.com/ddelange/pipgrip)

Vendors the [sdispater/mixology](https://github.com/sdispater/mixology) implementation of PubGrub for resolution. Works with `pip` and a requirements file.

Slower than poetry, but like poetry can resolve [cases](https://github.com/jazzband/pip-tools/issues/1187) pip-compile can't.

## performance

* pip-compile 6 sec
* poety 11 sec
* pipgrep 30 sec
