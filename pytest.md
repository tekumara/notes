# pytest

Stream stdout whilst running (equivalent to --capture=no)

```
pytest -s
```

Include INFO logs (defaults to WARNING). Will display on log failure.

```
pytest --log-level=INFO
```

Stream logs INFO or greater whilst running, and include time in log message:

```
pytest --log-cli-level=INFO --log-cli-format="%(asctime)s %(levelname)s %(message)s"
```

Run tests listing test names

```
pytest -v
```

Run tests which contain the string `perfect_data` and not the string `half` (case-insensitive)

```
pytest -k "perfect_data and not half"
```

Run test_execute with one of the parameterised variants named `parquet`:

```
pytest -k 'test_execute[parquet]'
```

Run test that exactly matches:

```
pytest tests/test_merge.py::test_transform_merge
```

List tests found:

```
pytest --collectonly
```

## Config files

_pytest.ini_:

```
[pytest]
addopts = "-s"
```

_pyproject.toml_:

```
[tool.pytest.ini_options]
addopts = "-s"
```

## Plugins

If you import plugins in _conftest.py_, eg:

```python
import fakesnow.fixtures
```

The IDE will be able to jump to their definition when used a function args.

You can enable them like this:

```
pytest_plugins = (fakesnow.fixtures.__name__,)
```

The downside of importing them is you can hit import errors when imported into a non-top dir conftest. Which is probably why the docs [suggest using a string literal](https://docs.pytest.org/en/stable/how-to/fixtures.html#using-fixtures-from-other-projects), eg:

```
pytest_plugins = ("fakesnow.fixtures",)
```

## Troubleshooting

### ModuleNotFoundError: No module named X

Make sure _tests/\_\_init\_\_.py_ exists.

If you still get the above when running `pytest` from the command line, run via the python interpreter:

```
python -m pytest [...]
```

This will add the current directory to `sys.path`, see [Calling pytest through python -m pytest](https://docs.pytest.org/en/latest/usage.html#calling-pytest-through-python-m-pytest)
