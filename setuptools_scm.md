# python package versioning with setuptools_scm

setuptools_scm generate a version number from the status of a git repository. The version number records the distance to the latest tag, including whether the repo is in an uncommitted (dirty) state. The version number is not committed to a file in repo.

To use setuptools_scm add this to setup.py

```python
    use_scm_version=True,
    setup_requires=['setuptools_scm'],
```

Versions are calculated from the git repo state as per [Default versioning scheme](https://github.com/pypa/setuptools_scm/#default-versioning-scheme).

To see the current version number:

```shell
$ python setup.py --version

0.1.dev13+g614e501.d20210327
```

When building an sdist the version will be writing into _PKG\_INFO_. It can be retrieved at runtime using _pkg_resources.get\_distribution_.

To avoid the overhead of _pkg_resources.get_distribution_, a version file can also be written:

```
    use_scm_version={
        'write_to': 'mypackage/version.py'
    }
```

The version should be added to .gitignore to avoid being committed.

## vs versioneer

versioneer works in a similar way to setuptools_scm but does not appear to be maintained.
