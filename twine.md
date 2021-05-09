# twine

Username and passwords can be stored in _~/.pypirc_

Check distributions

```
twine check dist/*`
```

Upload to the test pypi:

```
twine upload --repository testpypi dist/*
```
