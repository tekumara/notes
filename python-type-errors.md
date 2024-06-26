# python type errors

## Examples

### Argument of type "list[list[str]]" cannot be assigned to parameter "table" of type "List[List[str | None]]"

```python
from typing import List, Optional

def tbl(table: List[List[Optional[str]]]) -> None:
    pass

table = [["a", "b", "c"], ["aaaaaaaaaa", "b", "c"], ["a", "bbbbbbbbbb", "c"]]

tbl(table)
```

Produces:

```
  9:5 - error: Argument of type "list[list[str]]" cannot be assigned to parameter "table" of type "List[List[str | None]]" in function "tbl"
  TypeVar "_T" is invariant
    TypeVar "_T" is invariant
```

Most mutable [collections are invariant](https://mypy.readthedocs.io/en/stable/common_issues.html?highlight=invariant#invariance-vs-covariance).

Use an immutable collection instead, eg: `Sequence` instead of `List` or annotate the value with the matching type argument, eg: in the above example `List[List[Optional[str]]]`.

Invariance isn't allowed on mutable collections to avoid reassigning the type and then updating the underlying collection in ways that generate a runtime exception, eg:

```python
my_list_1: List[float] = [1, 2, 3]
my_list_2: List[Optional[float]] = my_list_1  # type error
my_list_2.append(None)

for elem in my_list_1:
    print(elem + 1)  # Runtime exception
```

More detail [here](https://github.com/microsoft/pyright/blob/main/docs/type-concepts.md#type-assignability).

### X is not a known member of module

eg:

```python
import structlog

shared_processors = [
    structlog.contextvars.merge_contextvars,
    structlog.processors.format_exc_info,
    structlog.processors.TimeStamper(fmt="iso"),
    structlog.stdlib.add_log_level,
    structlog.stdlib.add_logger_name,
    structlog.processors.UnicodeDecoder(),
]
```

`pyright --lib` produces:

```
  4:15 - error: "contextvars" is not a known member of module (reportGeneralTypeIssues)
```

To resolve add the following import:

```python
import structlog.contextvars
```

## Generic types can't be reassigned

```
from typing import List, Optional

a = list(["a", "b", "c"])
aopt2: List[Optional[str]] = a
```

Generates a type error `Type "str" cannot be assigned to type "str | None"` see [Type Concepts - Generic Types](https://github.com/microsoft/pyright/blob/master/docs/type-concepts.md#generic-types)

## .. is not exported from module .. (reportPrivateImportUsage)

`__all__` can be used to export imported names and resolve the `reportPrivateImportUsage` error. It won't affect type-checking behaviour for names in `__init__.py` that aren't imports. However, as a matter of convention [PEP 008](https://peps.python.org/pep-0008/#public-and-internal-interfaces) states modules should explicitly declare the names in their public API using the `__all__` attribute:

> To better support introspection, modules should explicitly declare the names in their public API using the `__all__` attribute. Setting `__all__` to an empty list indicates that the module has no public API.

Also [PEP 484](https://www.python.org/dev/peps/pep-0484/#stub-files) mentions that imported modules are not considered exported unless they use the `import ... as ...` syntax or equivalent.

## Type "Foo" is incompatible with type "Self@Foo"

```python
class Foo(StrEnum):
    BAR = "Bar"

    @classmethod
    def from_baz(cls, baz: Baz) -> Self:
        return Foo.__members__[baz]
```

> Expression of type "Foo" is incompatible with return type "Self@Foo"
> Type "Foo" is incompatible with type "Self@Foo"

Fix:

```python
    def from_baz(cls, baz: Baz) -> "Foo":
        return Foo.__members__[baz]
```

See [this comment](https://github.com/microsoft/pyright/issues/7712#issuecomment-2059690457):

> It's odd to use Self in an enum class the way you're doing here. Normally, Self is used to enable subclassing, but the runtime doesn't allow subclassing of enum classes, so this seems unnecessary.

When subclassing use `cls` see [Self - Use in Classmethod Signatures](https://typing.readthedocs.io/en/latest/spec/generics.html#use-in-classmethod-signatures)
