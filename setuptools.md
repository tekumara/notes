# setuptools

## source distributions

`python setup.py sdist` will build a source distribution (sdist) tar.gz archive in _dist/_. The sdist contains your project's source files, and additional metadata files in a \*_.egg-info/_ sub-directory.

Be sure to delete the _\*.egg-info/_ dir before running `python setup.py sdist` otherwise _SOURCES.txt_ will contain remnants of previous builds, eg: files that have since been deleted (see [setuptools/#2347](https://github.com/pypa/setuptools/issues/2347)).

The build process has the following stages:

1. create a sdist from a set of sources
1. build a wheel will from that sdist

pip will then install the wheel into site-packages (pip will also build a wheel from an sdist if the wheel doesn't exist).

### Files in the source dist

A package is a directory with a `__init.__.py` file. Package data files are non `.py` files inside a package directory. Non-package data files are files in the root directory or outside your package like _requirements.txt_.

setuptools will automatically include your package's `.py`` files in the source dist.

By default this includes python source files implied by the `packages` setup.py arguments. [`packages = find_packages()`](https://setuptools.pypa.io/en/latest/userguide/package_discovery.html) walks the target directory and finds any packages. Packages are only recognized if they include an `__init__.py` file. eg: to include all packages except tests in the source dist:

_setup.py_:

```python
packages=find_packages(exclude=["tests"]),
```

_pyproject.toml_:

```toml
[tool.setuptools.packages.find]
where = ["."]
exclude = ["tests*"]
```

However non .py files, or files generated during your build, won't be included by default unless you use either

- an SCM plugin like setuptools_scm to automatically include all files being tracked by git.
- a MANIFEST.in to modify the default set of files included in the source dist. See [Controlling files in the distribution](https://setuptools.pypa.io/en/latest/userguide/miscellaneous.html) and [Including files in source distributions with MANIFEST.in](https://packaging.python.org/guides/using-manifest-in/).

Any files included in the source dist will be available to setup.py during the install process. The set of source files contained within the sdist is listed in _\*.egg-info/SOURCES.txt_.

### Files in the wheel

`include_package_data = True` will include package data files (ie: non .py files inside packages) from the sdist/SOURCES.txt in the wheel. By default, `include-package-data = true` in pyproject.toml.

By default, files outside package directories are not included. eg: if you use setuptools-scm and have a _tests_ directory outside of the package folder and a _requirements.txt_ in the root, then these will be present in the sdist by not the wheel.

`package_data` can specify additional fine-grained patterns of package files to include. These files must exist inside a package. Non-package files cannot be included. Files specified here that aren't included in MANIFEST.in or by an SCM plugin will be added to the source dist, which can include files generated during build.

`exclude` can be used to exclude files from the wheel only (use MANIFEST.in to exclude them from the sdist). If they are excluded in the MANIFEST.in only but not `[tool.setuptools.packages.find]` they will still appear in the wheel.

`data_files` is deprecated and does not work with wheels.

For more info see:

- [Data Files Support](https://setuptools.pypa.io/en/latest/userguide/datafiles.html)
- [setuptools/#3148](https://github.com/pypa/setuptools/pull/3148) also [setuptools/#1461](https://github.com/pypa/setuptools/issues/1461) and [setuptools/#2835](https://github.com/pypa/setuptools/pull/2835#issuecomment-956123517)).

## PEP 517 support

[PEP 517](https://www.python.org/dev/peps/pep-0517/) is a new minimal interface for any build tool that wants to build sdists or wheels, and have them installed via pip. It introduces a `build-backend` configuration value to the `[build-system]` section of _pyproject.toml_ which tells pip (or other tools like tox) how to build a sdist or wheel.

[setuptools build_meta](https://setuptools.readthedocs.io/en/latest/build_meta.html) provides a PEP 517 interface to setuptools.
