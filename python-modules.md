# Python modules

## Python import system

- A file ending in .py is a module
- In Python 2.7, a collection of modules under one directory with a `__init.__.py` file (empty or otherwise) is a package
- In Python 3.3, any directory on `sys.path` with a name that matches an imported package name will contribute modules and sub-packages to that package.
- `PYTHONPATH` - augment the default search path (`sys.path`) that python uses to locate modules
- Any directory with a `__main__.py` is treated as an executable
- `python -m package` will execute `package/__main__.py` if it exists
- The `zipimport` module will treat a zip file as a module, ie: if it contains a `__init__.py` it will be considered a package, it if has a `__main__.py` it will be considered an executable.

See

- [PyBay2016 - Cindy Sridharan - The Python Deployment Albatross](https://speakerdeck.com/pybay/2016-cindy-sridharan-the-python-deployment-albatross)
- [Traps for the Unwary in Python’s Import System](http://python-notes.curiousefficiency.org/en/latest/python_concepts/import_traps.html)
- [Practical Python - 9.1 Packages](https://github.com/dabeaz-course/practical-python/blob/main/Notes/09_Packages/01_Packages.md)

## PYTHONPATH

`PYTHONPATH` can contain a directory of modules (ie: .py files) or .zip/.egg files. Python will unpack the .zip file and locate any packages within it ie: directories containing a _\_\_init\_\_.py_ file. The name of the .zip file is irrelevant.

## Import time

At import time, everything in the top level of the script is executed.

Functions and anything under:

```
if __name__ == '__main__':
```

will execute when invoked at runtime.

## sys.path on startup

From the [sys.path](https://docs.python.org/3/library/sys.html#sys.path) docs:

> As initialized upon program startup, the first item of this list, path[0], is the directory containing the script that was used to invoke the Python interpreter.

eg:

| command                                                  | sys.path[0]                                        |
| -------------------------------------------------------- | -------------------------------------------------- |
| `python`                                                 | empty string (`''`) so python searches current dir |
| `python script.py`                                       | current dir                                        |
| `python myscripts/script.py`                             | myscripts/                                         |
| `python -m myscripts.script`                             | current dir                                        |
| `/usr/local/bin/entrypoint` (script with python shebang) | /usr/local/bin                                     |

## Relative imports

```
$ python cli.py
Traceback (most recent call last):
  File "cli.py", line 10, in <module>
    from .utils import helper_function
ModuleNotFoundError: No module named '__main__.utils'; '__main__' is not a package
```

`.utils` is a relative import and refers to the utils module relative to the current package (ie: current directory).
Because python is running a script (`cli.py`), `__main__` is the name of the package.
But `__main__` isn't a package, so the relative import can't be resolved and this error occurs.

If you run this as a module:

```
$ python -m cli
...
    from .utils import helper_function
ImportError: attempted relative import with no known parent package
```

This occurs because there is no package when you start python inside the same directory as `cli.py`

Solutions:

- Load `cli` as a module but supply the package name, eg: `python -m data_pipeline.cli`
- Don't use relative imports, eg: replace `from .utils` -> `from data_pipeline.utils`. This will work both when running as a script or a module.

See [Script vs. Module](https://stackoverflow.com/a/14132912/149412)

The google python style guide [does not recommend](http://google.github.io/styleguide/pyguide.html#224-decision) relative imports.

## Troubleshooting

To see all available modules: `help("modules")`

To see details of a module:

```
help()
module_name
```

To see location: `module_name.__file__`

### ImportError: cannot import name X

Make sure you don't have circular module imports. Moving one of the imports to be local to its invocation might help, or better yet, remove the circular dependency.

Check your version of the dependency (or python) has the import.

### ModuleNotFoundError: No module named X

When the python interpreter runs, it add the current directory to sys.path (ie: PYTHONPATH), eg:

- `python myapp/flows.py` will add _myapp/_ to the sys.path
- `python -m myapp.flows` will add _./_ to the sys.path

To see where a module is being imported from:

```
>>> import ebbcore.show_environments
Traceback (most recent call last):
  File "/usr/lib/python3.6/code.py", line 91, in runcode
    exec(code, self.locals)
  File "<console>", line 1, in <module>
ModuleNotFoundError: No module named 'ebbcore.show_environments'
>>> print(ebbcore.__file__)
/home/tekumara/.local/lib/python3.6/site-packages/ebbcore/__init__.py
```

In the above case, it looks like an old version of the package is being imported, that doesn't have the module `ebbcore.show_environments`.

Inspect the sys.path:

```
>>> import sys; sys.path
['./ebbp', '/usr/lib/python36.zip', '/usr/lib/python3.6', '/usr/lib/python3.6/lib-dynload', '/home/tekumara/.local/lib/python3.6/site-packages', '/usr/local/lib/python3.6/dist-packages', '/usr/lib/python3/dist-packages', '/home/tekumara/.shiv/ebbp_921c47de-78d9-4ce4-a4cd-28426ed667e2/site-packages']
```

If you modify the path so the latest version takes precedence, you can the reload that version (reload is required because we've already loaded the old version above):

```
>>> sys.path.insert(1, '/home/tekumara/.shiv/ebbp_921c47de-78d9-4ce4-a4cd-28426ed667e2/site-packages')
>>> import ebbcore
>>> import importlib
>>> importlib.reload(ebbcore)
<module 'ebbcore' from '/home/tekumara/.shiv/ebbp_921c47de-78d9-4ce4-a4cd-28426ed667e2/site-packages/ebbcore/__init__.py'>
>>> import ebbcore.show_environments
```

If you start with `python3 -sE` then:
`-s` no user site-packages directories with be added to `sys.path`
`-E` any `PYTHON*` environment variables will be ignored, including `PYTHONPATH`

However, dist-packages directories will still be on the path.

### ImportError: No module named X

If you get the above when running `pytest` from the command line, run via the python interpreter:

```
python -m pytest [...]
```

This will add the current directory to `sys.path`, see [Calling pytest through python -m pytest](https://docs.pytest.org/en/latest/usage.html#calling-pytest-through-python-m-pytest)

## importlib_metadata.PackageNotFoundError: No package metadata was found for package_X

Can occur when the `package_X.egg-info` directory for a linked editable package is missing. Reinstall the package, eg: `pip install -e package_X`
