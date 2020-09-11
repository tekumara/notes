# Python distribution packages

[_import package_](https://packaging.python.org/glossary/#term-import-package): a collection of modules under one directory with a `__init.__.py` file (empty or otherwise)  
[_distribution package_](https://packaging.python.org/glossary/#term-distribution-package): an archive containing import packages and metadata for release and distribution.

## Distributions

_sdist_: source distribution. Source files + metadata in a source archive, ie: a `tar.gz`. Will require a compiler toolchain to build any C extensions. During pip install, _setup.py_ is run to build a wheel.

_bdist_wheel_: binary distribution, packaged as a wheel file, ie: a `.whl` file which is a gzipped tar containing built binaries + metadata (dist-info) without setup.py. Doesn't require a C compile step. Creates `.pyc` files during installation to match the python interpreter used. Built for a particular OS and version of python eg: `pybay-1.0-3.0-py27-abi3-inux_x86_64.whl`.

git repo: pip can install from a git repo. It treats the git repo as a source dist.

> "Newer pip versions preferentially install built distributions, but will fall back to source archives if needed. You should always upload a source archive and provide built archives for the platforms your project is compatible with."

## setup.py

`setup.py` is the build script for distutils or the newer [setuptools](https://setuptools.readthedocs.io/en/latest/index.html).

A minimal setup.py:

```
from setuptools import setup, find_packages

setup(
    name='epr',
    version='0.1',
    description='emr-pipeline-runner',
    packages=find_packages(exclude=["tests"]),
    python_requires=">=3.6",
)
```

`find_packages` will find all the import packages (ie: directories) in your source tree. Without it the distribution will be empty. Alternatively you can specify packages manually.  
`python_requires` specified the minimal python version. If this isn't present the installation will fail.

Read dependencies from `requirements.txt` as follows:

```
from pathlib import Path

from setuptools import setup, find_packages

install_requires = Path("requirements.txt").read_text()

setup(
    name='epr',
    version='0.1',
    description='emr-pipeline-runner',
    packages=find_packages(exclude=["tests"]),
    python_requires=">=3.6",
    install_requires=install_requires,
)
```

`install_requires` specifies dependencies that pip will install along with your distribution package.

## wheel

Install wheel: `pip install wheel`  
Build a wheel: `python setup.py bdist_wheel`

Example uncompressed wheel file directory tree:

```
pyspark/
pyspark-2.4.4.data/
pyspark-2.4.4.dist-info/
```

## pex

An executable python zip package, ie:

```
echo "#'!'usr/bin/env python" > pybay.pex
cat /tmp/pybay.zip >> pybay.pex
chmod +x pybay.pex
./pybax.pex
```

## shiv

```
## build wheel
dist: $(venv) $(shell find tools) setup.py
	rm -rf build dist
	$(python) setup.py bdist_wheel --dist-dir dist

## build shiv
asak: dist
	$(venv)/bin/shiv -c asak -o asak -p "/usr/bin/env python3" -r requirements.txt dist/asak*.whl
	@ echo "Created ./asak"
```

## Naming

The distribution package name (ie: in setup.py the `name` field) can contain hyphens. The import packages inside the distribution cannot. PEP8 discourages the use of underscores for import package names, but you will often seen them. Top-level import package names should be unique within site-packages.

## References

- [Python Packaging User Guide - Glossary](https://packaging.python.org/glossary/)
- [Distributing Python Modules](https://docs.python.org/3.8/distributing/index.html#distributing-index)
- [PyBay2016 - Cindy Sridharan - The Python Deployment Albatross](https://speakerdeck.com/pybay/2016-cindy-sridharan-the-python-deployment-albatross)
- [Testing your python package as installed](https://blog.ganssle.io/articles/2019/08/test-as-installed.html)
