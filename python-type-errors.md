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
