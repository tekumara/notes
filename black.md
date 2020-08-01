# black

* lots of import lines when wrapped
* removes parenthesis around lines
* removes semantic line breaks that allow you to provide structure to multiple lines
* will add trailing full stops to doc string lines

## vs autopep8

Makes very minimal changes and allows semantic formatting.

### Trailing comma

```python
foo = [1,2,3,]
```

black:

```python
    foo = [
        1,
        2,
        3,
    ]
```

autopep8:

```python
foo = [1, 2, 3, ]
```

## with isort

To make isort's output black compatible:

```ini
[tool.isort]
# make isort compatible with black
line_length = 88
multi_line_output = 3
include_trailing_comma = true
```
