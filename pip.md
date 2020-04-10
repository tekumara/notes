# pip

`pip install $package` will install into the global site packages dir. If using pyenv this will be something like `~/.pyenv/versions/3.7.5/lib/python3.7/site-packages/`

`pip install --user $package` will install into `~/.local/lib/python$x.$y/site-packages`

These packages will be available in all versions of python$x.$y.z, ie: all versions of python3.6, or python3.7

`pip install --user` will also install scripts into `~/.local/bin` with a shebang line referencing the version of python used at the time of install. This means these scripts can be run regardless of the active python version.

`pip uninstall` will not remove transitive packages or the scripts they install into `~/.local/bin`. [pip-autoremove](https://github.com/invl/pip-autoremove) will.

`pip show $package` will show immediate dependencies of a package (but not recursively, use pipdeptree for this) and the location of a package


## Troubleshooting

```
ERROR: aec 0.1 has requirement boto3==1.9.130, but you'll have boto3 1.10.45 which is incompatible.
```
or
```
pkg_resources.ContextualVersionConflict: (boto3 1.10.45 (/Users/tekumara/.virtualenvs/aec/lib/python3.6/site-packages), Requirement.parse('boto3==1.9.130'), {'aec'})
```

The package aec in the current environment expects a different version of boto3 from the one you have just installed.

The required versions are specified in `$package_name.egg-info/requires.txt`.

If this is an editable package this will be located in the source code directory.

If `requires.txt` is out-of-sync from the source's `setup.py` then reinstalling will update it, ie: `pip install -e .` 