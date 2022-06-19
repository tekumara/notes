# pytest

Stream stdout whilst running

```
pytest -s
```

List test names

```
pytest -v
```

Run tests which contain the string `perfect_data` and not the string `half` (case-insensitive)

```
pytest -k "perfect_data and not half" -v
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

## Troubleshooting

### ModuleNotFoundError: No module named X

Make sure _tests/\_\_init\_\_.py_ exists.

If you still get the above when running `pytest` from the command line, run via the python interpreter:

```
python -m pytest [...]
```

This will add the current directory to `sys.path`, see [Calling pytest through python -m pytest](https://docs.pytest.org/en/latest/usage.html#calling-pytest-through-python-m-pytest)
