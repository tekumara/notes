# pip

## Usage

- `pip install $package` will install into the global site packages dir. If using pyenv this will be something like _~/.pyenv/versions/3.7.5/lib/python3.7/site-packages/_
- `pip install --user $package` will install into _~/.local/lib/python$x.$y/site-packages_. These packages will be available in all versions of _python$x.$y.z_, eg: all versions of _python3.6_, or _python3.7_. Scripts will be installed into _~/.local/bin_ with a shebang line referencing the version of python used at the time of install. This means these scripts can be run regardless of the active python version.
- `pip uninstall` will not remove transitive packages or any scripts installed into _~/.local/bin_. [pip-autoremove](https://github.com/invl/pip-autoremove) will.
- `pip show $package` will show immediate dependencies of a package (but not recursively, use [pipdeptree](https://github.com/naiquevin/pipdeptree) for this) and the location of a package

Install using a named urlspec from a git branch with dev extras:

```
pip install 'aec[dev] @ git+https://github.com/seek-oss/aec.git@master'
```

Inst

## Troubleshooting

```
ERROR: aec 0.1 has requirement boto3==1.9.130, but you'll have boto3 1.10.45 which is incompatible.
```

or

```
pkg_resources.ContextualVersionConflict: (boto3 1.10.45 (/Users/tekumara/.virtualenvs/aec/lib/python3.6/site-packages), Requirement.parse('boto3==1.9.130'), {'aec'})
```

The package _aec_ in the current environment expects a different version of _boto3_ from the one you have just installed. The required versions are specified in _\$package_name.egg-info/requires.txt_. If this is an editable package this will be located in the source code directory.

It may be that _requires.txt_ is out-of-sync from the editable package's _setup.py_. In which case reinstalling will update it, ie: `pip install -e .`

## Local project installs

Install a copy of the package located at ../spark_data_testing into your site-packages dir:

```
pip install ../spark_data_testing
```

Install an editable version which points to the source in its original location, rather than a copy.

```
pip install -e ../spark_data_testing
```

This will create a `spark-data-testing.egg-link` file in your site-packages dir. It has the effect of placing your source directory on `PYTHONPATH`.

See [Local Project Installs](https://pip.pypa.io/en/stable/reference/pip_install/#local-project-installs)

### Paths

`../spark_data_testing` is the same as `file:../spark_data_testing`

Any URL may use the `#egg=name` prefix to explicitly state the project name. When using `#egg=name` you need to use a url `file:`

## VCS installs

A VCS install uses the contents of the repo as the sdist, from which to build a wheel.

To install from a subdirectory in a git repo using ssh:

```
pip install 'git+ssh://git@github.com/tekumara/lab.git#egg=ebse&subdirectory=ebs_encrypter'
```

[ref](https://pip.pypa.io/en/stable/reference/pip_install/#vcs-support)

## Wheels

When no wheels are found for an sdist or VCS repo, pip will attempt to build a wheel automatically and insert it into the wheel cache.
