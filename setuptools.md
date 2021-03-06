# setuptools

## source distributions

`python setup.py sdist` will build a source distribution (sdist) tar.gz archive in _dist/_. The sdist contains a subset of your project's files, as specified in `setup.py`, and additional metadata files in a \*_.egg-info/_ sub-directory.

During pip install, a wheel is built from the sdist.

Be sure to delete the _\*.egg-info/_ dir before running `python setup.py sdist` otherwise _SOURCES.txt_ will contain remnants of previous builds, eg: files that have since been deleted (see [setuptools/#2347](https://github.com/pypa/setuptools/issues/2347)).

A package is a directory with a `__init.__.py` file.

### MANIFEST.in

MANIFEST.in can be used to modify the default set of files included in the source dist.

The default set includes python source files implied by the `packages` setup.py arguments. [`packages = find_packages()`](https://setuptools.readthedocs.io/en/stable/userguide/package_discovery.html) walks the target directory and finds any packages. Packages are only recognized if they include an `__init__.py` file. You probably want to exclude tests otherwise they will be included in the source dist, and installed into site-packages.

eg: to include all packages except tests in the source dist:

```python
packages=find_packages(exclude=["tests"]),
```

Specify package data files in MANIFEST.in to include them in the source dist. Non-package data files can also be included, eg: files in the root directory like _requirements.txt_.

Any files included in the source dist will be available to setup.py during the install process. The source dist files are listed in _\*.egg-info/SOURCES.txt_ is the set of files contained within the sdist.

See [Including files in source distributions with MANIFEST.in](https://packaging.python.org/guides/using-manifest-in/)

### Specifying files to install from a sdist

`include_package_data = True` will install all package data files in the source dist (ie: specified in MANIFEST.in) into the package's dir in _site-packages_.

`package_data` can specify additional fine-grained patterns of files to install. These may be files included in the source dist by MANIFEST.in, files that aren't in MANIFEST.in and will be added to the source dist, or files that are generated by your setup script during install. Contrary to the [docs](https://setuptools.readthedocs.io/en/latest/userguide/datafiles.html), `include_package_data = True` and package_data can both be specified, and the union of package_data and MANIFEST.in will be installed into site-packages, (see also [setuptools/#1461](https://github.com/pypa/setuptools/issues/1461)).

`data_files` is deprecated and does not work with wheels.

See [Including Data Files](https://web.archive.org/web/20200919125552/https://setuptools.readthedocs.io/en/stable/setuptools.html#including-data-files).

## PEP 517 support

[PEP 517](https://www.python.org/dev/peps/pep-0517/) is a new minimal interface for any build tool that wants to build sdists or wheels, and have them installed via pip. It introduces a `build-backend` configuration value to the `[build-system]` section of _pyproject.toml_ which tells pip (or other tools like tox) how to build a sdist or wheel.

[setuptools build_meta](https://setuptools.readthedocs.io/en/latest/build_meta.html) provides a PEP 517 interface to setuptools.
