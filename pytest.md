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

## Troubleshooting

### ModuleNotFoundError: No module named X

Make sure _tests/\_\_init\_\_.py_ exists.

If you still get the above when running `pytest` from the command line, run via the python interpreter:

```
python -m pytest [...]
```

This will add the current directory to `sys.path`, see [Calling pytest through python -m pytest](https://docs.pytest.org/en/latest/usage.html#calling-pytest-through-python-m-pytest)
