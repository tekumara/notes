# pytest

Show stdout

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
