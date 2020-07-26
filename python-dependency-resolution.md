# python dependency resolution

pip lacks a dependency resolver.

## pip-compile

pip-compile will resolves packages for the same Python version and OS it is running on. Works with `pip` and a requirements file.

The resolver is faster than poetry, if not using hashes.

`pip-compile --generate-hashes` will generate hashes which takes a lot longer if packages are not already in the cache

`pip-sync` doesn't check hashes - yet, see [#706](https://github.com/jazzband/pip-tools/pull/706)

## poetry

poetry offers package management with dependency resolution, essentially replacing pip and setuptools. This means that poetry packages don't contain `setup.py`, and hence are not compatible with `pip install -e`.

Instead dependencies are specified in `pyproject.toml` and resolved to `poetry.lock`. `poetry export -f requirements.txt` will export resolved dependencies to requirements.txt format.

poetry is slower than pable to resolve [cases](https://github.com/jazzband/pip-tools/issues/1187) pip-compile can't.

## [pipgrip](https://github.com/ddelange/pipgrip)

Vendors the [sdispater/mixology](https://github.com/sdispater/mixology) implementation of PubGrub for resolution. Works with `pip` and a requirements file.

Slower than poetry, but like poetry can resolve cases pip-compile can't.

## performance

pip-compile 6 sec
poerty 11 sec
pipgrep 30 sec
