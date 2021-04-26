# python type checking

## TypedDict

eg:

```python
class Config(TypedDict):
    vpc: Dict[str, str]
```

A dictionary must have the field vpc to be of type `Config`.

A [non-total type](https://mypy.readthedocs.io/en/stable/more_types.html#totality) does not require all fields to be present, eg:

```python
class Config(TypedDict, total = False):
    vpc: Dict[str, str]
```

A dictionary can be inferred as a TypedDict when supplied as a function argument, but requires an explicit annotation when assigned to a variable ([ref](https://github.com/microsoft/pyright/issues/1727#issuecomment-813123780)).

## Ignore

Add `# type: ignore` to the end of a line to disable type checking, or the top of the file to disable type-checking for the whole module.

For multi-line statements, use PEP8's implied line continuation inside parentheses: eg:

```python
  return (
      df1._jdf.showString(NUM_ROWS, TRUNCATE, VERTICAL) + "\n" +  # type: ignore
      df2._jdf.showString(NUM_ROWS, TRUNCATE, VERTICAL)           # type: ignore
  )
```

## Generics

Type variables that range over a set of types can be specified using TypeVar, eg:

```python
# any type
RequestType = TypeVar("RequestType")

# with value restriction
E = TypeVar("E", bool, int, float)
```

See [mypy - Generics](https://mypy.readthedocs.io/en/stable/generics.html)

## References

- [Tagged unions aka sum types](https://mypy.readthedocs.io/en/stable/literal_types.html#tagged-unions)
