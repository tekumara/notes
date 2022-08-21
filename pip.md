# pip

## Usage

- `pip install $package` will install into the global site packages dir. If using pyenv this will be something like _~/.pyenv/versions/3.7.5/lib/python3.7/site-packages/_
- `pip install --user $package` will install into _~/.local/lib/python$x.$y/site-packages_. These packages will be available in all versions of _python$x.$y.z_, eg: all versions of _python3.6_, or _python3.7_. Scripts will be installed into _~/.local/bin_ with a shebang line referencing the version of python used at the time of install. This means these scripts can be run regardless of the active python version.
- `pip uninstall` will not remove transitive packages or any scripts installed into _~/.local/bin_. [pip-autoremove](https://github.com/invl/pip-autoremove) will.
- `pip show $package` will show immediate dependencies of a package (but not recursively, use [pipdeptree](https://github.com/naiquevin/pipdeptree) for this) and the location of a package

## Local project installs

Install a copy of the package located at ../spark_data_testing into your site-packages dir:

```
pip install ../spark_data_testing
```

Install an editable version which points to the source in its original location, rather than a copy.

```
pip install -e ../spark_data_testing
```

This will create a `spark-data-testing.egg-link` file in your site-packages dir. It has the effect of placing your source directory on `PYTHONPATH`. All packages under the source directory will be accessible, even if they are not included in the source dist.

See [Local Project Installs](https://pip.pypa.io/en/stable/reference/pip_install/#local-project-installs)

### Paths

`../spark_data_testing` is the same as `file:../spark_data_testing`

Any URL may use the `#egg=name` prefix to explicitly state the project name. When using `#egg=name` you need to use a url `file:`

## VCS installs

A VCS install uses the contents of the repo as the sdist, from which to build a wheel. The repo is cloned first.

Install using a named urlspec from a git branch with dev extras:

```
pip install 'aec[dev] @ git+https://github.com/seek-oss/aec.git@master'
```

Install a pip request

```
pip install 'dbt-snowflake @ git+https://github.com/dbt-labs/dbt-snowflake.git@refs/pull/65/head'
```

Install from a subdirectory in a git repo using ssh:

```
pip install 'git+ssh://git@github.com/tekumara/lab.git#egg=ebse&subdirectory=ebs_encrypter'
```

References:

- [pip install - VCS Support](https://pip.pypa.io/en/stable/cli/pip_install/#vcs-support)
- [PEP 508 -- Dependency specification for Python Software Packages](https://www.python.org/dev/peps/pep-0508/)

## Wheels

When no wheels are found for an sdist or VCS repo, and the wheel package is installed, pip will attempt to build a wheel automatically using the build system, insert it into the wheel cache, and install the wheel metadata into an adjacent _dist-info_ directory.

pip builds in a isolated environment that includes any requirements defined in `[build-system]` in _pyproject.toml_ (or the latest version of setuptools and wheel if now is specified). See [PEP 517 and 518 support](https://pip.pypa.io/en/stable/cli/pip/#pep-517-and-518-support).

If the wheel package is not installed pip will fallback to `setup.py install` which will copy the source files and create source package metadata in an adjacent _egg-info_ directory.

## Cache

The wheel cache is located at `$(pip cache dir)\wheels`. It can be inspected via `pip cache list`.

The http cache (aka package index page cache) is located at `$(pip cache dir)\http`. Use the file system to inspect it. Each repository has caches packages separately.

See [pip documentation: Caching](https://pip.pypa.io/en/stable/cli/pip_install/#caching)

## Updating dependencies

Show outdated deps and their latest versions:

```
pip list --outdated
```

[pipupgrade](https://github.com/achillesrasquinha/pipupgrade) can automatically update requirements.txt

## Trouble shooting

> pip.\_vendor.pkg_resources.ContextualVersionConflict: (typing-extensions 4.2.0 (/home/runner/work/aec/aec/.venv/lib/python3.7/site-packages), Requirement.parse('typing_extensions==4.3.0'), {'aec-cli'})

There's already a version installed in the virtualenv (ie: 4.2.0) that conflicts with the requirement to install version 4.3.0.
