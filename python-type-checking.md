# python type checking

## TypedDict

eg:

```python
class Config(TypedDict):
    vpc: Dict[str, str]
```

A dictionary must have the field vpc to be of type `Config`.

A [non-total TypedDict](https://mypy.readthedocs.io/en/stable/more_types.html#totality) does not require all fields to be present, eg:

```python
class Config(TypedDict, total = False):
    vpc: Dict[str, str]
```

A dictionary can be inferred as a TypedDict when supplied as a function argument, but requires an explicit annotation when assigned to a variable ([ref](https://github.com/microsoft/pyright/issues/1727#issuecomment-813123780)).

A TypedDict is not compatible with `Dict[str, Any]` because it is considered a mutable invariant collection, see [mypy #4976](https://github.com/python/mypy/issues/4976).

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

`TypeVar` can be used to specify a [type variable](https://www.python.org/dev/peps/pep-0483/#type-variables), eg:

```python
# ranges over any type
RequestType = TypeVar("RequestType")

# constrained to specific types
E = TypeVar("E", bool, int, float)
```

See also [mypy - Generics](https://mypy.readthedocs.io/en/stable/generics.html)

## Inspection

Use `reveal_type` to tell the type checker to print out the type, eg:

```python
    reveal_type(arg1)
```

`reveal_type` is not defined at runtime and will raise a NameError.

## cast

`typing.cast` tells the type-checker the value has the specified type. At runtime `cast` is a no-op that returns the value it was passed.

```python
from typing import cast

header = cast(List[str], rows[0])
```

See [mypy - Casts and type assertions](https://mypy.readthedocs.io/en/stable/casts.html)

## isinstance

`isinstance` can be used at runtime to determine an object's class. It cannot be used to check for a Generic or Literal type. Type checkers will use `isinstance` checks to narrow the type of a variable.

## Overloading

Overloading allows a function to have multiple type signatures. This can allow a more precise description of a flexible function than using Union types. At runtime there is still only one implementation of the function (unlike other languages like Java which will select the appropriate method at compile time).

See [mypy - Function overloading](https://mypy.readthedocs.io/en/stable/more_types.html#function-overloading)

## Troubleshooting

```

def first_name(names: pd.Series[str]) -> List[str]:
    pass

TypeError: 'type' object is not subscriptable
```

This runtime error occurs because the runtime tries to evaluate the expression `pd.Series[int]`. Series does not extend `Generic`, unlike the [python pandas stubs](https://github.com/microsoft/python-type-stubs/blob/main/pandas/core/series.pyi#L51) which do. `Generic` provides a metaclass that overloads the indexing operator to a no-op.

The solution here is to wrap the type annotation in quotes. The annotation remains visible to the type checker, but avoids the runtime error because the expression is now a string. eg:

```
def first_name(names: "pd.Series[str]") -> List[str]:
    pass
```

([ref])(https://github.com/python/typing/issues/410#issuecomment-293263300)

## References

- [Tagged unions aka sum types](https://mypy.readthedocs.io/en/stable/literal_types.html#tagged-unions)
- [python/typing issues](https://github.com/python/typing/issues)
- [typing-sig mailing list archives](https://mail.python.org/archives/list/typing-sig@python.org/)
