# python type checking

## TypedDict

I'd probably default to NamedTuples or Dataclasses, and use TypedDicts for special situations that require interoperability (eg: with pandas) or backwards compatibility. Unlike dataclasses they

- don't support attribute access (eg: `Order.id`)
- can't have methods
- can only inherit from other `TypedDicts` so aren't great for building class hierarchies, eg: if you try to inherit from a TypedDict and Protocol you'll get a `TypeError: cannot inherit from both a TypedDict type and a non-TypedDict base class`. In python 3.11 there so support however for [TypedDict to inherit from Generic](https://github.com/python/cpython/issues/89026#issuecomment-1116093221) and a special case.
- a dictionary can be inferred as a TypedDict when supplied as a function argument or returned from a function, but requires an explicit annotation when assigned to a variable ([ref](https://github.com/microsoft/pyright/issues/1727#issuecomment-813123780)). So we don't have a way of typechecking construction when assigned to a variable.

NB: TypedDict can't be inferred when using a [dict constructor](https://github.com/microsoft/pyright/issues/6051), use a dict literal instead.

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

To specify which fields are required and which ones aren't, use inheritance:

```python
class _RequiredRunArgs(TypedDict, total=True):
    MaxCount: int
    MinCount: int

class RunArgs(_RequiredRunArgs, total=False):
    BlockDeviceMappings: List["BlockDeviceMappingTypeDef"]
    ImageId: str
    InstanceType: InstanceTypeType
...
```

NB: [PEP 655](https://typing.readthedocs.io/en/latest/spec/typeddict.html#required-notrequired) introduces a new syntax for this in Python 3.10.

A TypedDict is not compatible with `dict`, because it is [considered a mutable invariant collection](https://github.com/python/mypy/issues/4976), eg:

```
Argument of type "Animal" cannot be assigned to parameter "_" of type "dict[Unknown, Unknown]" in function "fn_covariant"
  "Animal" is incompatible with "dict[Unknown, Unknown]"
```

Use a `Mapping` instead, eg:

```python
from collections.abc import Mapping
from typing import TypedDict


class Animal(TypedDict):
    type: str


def fn_covariant(_: dict) -> None:
    pass


def fn_invariant(_: Mapping) -> None:
    pass


cat: Animal = {"type": "cat"}

fn_covariant(cat)  # <- errors
fn_invariant(cat)
```

## Collections and variance

Mutable collections have invariant type parameters because the contents of the collection can change.
Immutable collection types support covariant type parameters, so derived classes and Union elements are allowed.

| Mutable Type | Immutable Type     |
| ------------ | ------------------ |
| List         | Sequence, Iterable |
| Dict         | Mapping            |
| Set          | AbstractSet        |
| n/a          | Tuple              |

See [pyright: Understanding Typing - Generic Types](https://github.com/microsoft/pyright/blob/c83a95e/docs/type-concepts.md#generic-types)

eg:

```python
from collections.abc import Sequence


def fn_invariant(_: list[str | None]) -> None:
    pass


def fn_covariant(_: Sequence[str | None]) -> None:
    pass


ls = ["a", "b", "c"]

fn_invariant(ls) # <- errors
fn_covariant(ls)
```

pyright:

```
14:14 - error: Argument of type "list[str]" cannot be assigned to parameter "_" of type "list[str | None]" in function "fn_invariant"
    "list[str]" is incompatible with "list[str | None]"
      Type parameter "_T@list" is invariant, but "str" is not the same as "str | None"
```

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

To reduce redundancy, defaults and return values can be replaced with `...`. Not however this is what the type checker will reveal as the type, rather then its actual value,

See [mypy - Function overloading](https://mypy.readthedocs.io/en/stable/more_types.html#function-overloading)

### Overloads with optional params

To make a second param optional, make it a keyword only param, eg:

```python
    @overload
    def upsert(self, upsert: Chunk | list[Chunk], delete: None = None) -> None:
        ...

    @overload
    def upsert(self, upsert: None = None, *, delete: Chunk | list[Chunk]) -> None:
        ...

    @overload
    def upsert(self, upsert: Chunk | list[Chunk], delete: Chunk | list[Chunk]) -> None:
        ...

    def upsert(self, upsert: Chunk | list[Chunk] | None = None, delete: Chunk | list[Chunk] | None = None) -> None:
```

See [this comment](https://github.com/python/mypy/issues/5486#issuecomment-413229343).

## Subclasess

```
class B:
    pass

class A(B):
    pass

def f(b: B) -> None:
    pass

f(A)
```

Produces the type error `"f" has incompatible type "Type[A]"; expected "B"`

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

([ref](https://github.com/python/typing/issues/410#issuecomment-293263300))

```
def f(a: A) -> None:
    pass

f(A)

Argument of type "Type[A]" cannot be assigned to parameter "a" of type "A" in function "f"
  "Type[type]" is incompatible with "Type[A]"
```

Pass the instance instead of the type, eg: `f(A())`

## TypeVar bound in type alias is ignored

Generic type aliases (ie: a type alias containing a `TypeVar`) must have their type parameter specified when the alias is used. If not, `Any` is assumed, see [mypy - Generic type aliases](https://mypy.readthedocs.io/en/stable/generics.html#generic-type-aliases):

> Unsubscripted aliases are treated as original types with free variables replaced with Any.

eg:

```python
import typing

E = typing.TypeVar("E", bound="Exception")
ExceptionHandler = typing.Callable[[int, E], int]


class MyError(Exception):
    pass


class Foo:
    pass


def handle(_: ExceptionHandler) -> None:
    pass


def my_exception_handler(_i: int, _e: MyError) -> int:
    return 42


# does not generate a type error because ExceptionHandler is unsubscripted therefore E is Any
handle(my_exception_handler)
```

To fix provide the type parameter when using the alias, eg:

```python
def handle(_: ExceptionHandler[E]) -> None:
    pass
```

See also:

- [explanation in pyright](https://github.com/microsoft/pyright/issues/6715#issuecomment-1852429229)

## Variance

```python
from typing import Protocol


class Data(Protocol):
    text: str


class MyData(Data):
    text: str


class Model(Protocol):
    def embed(self) -> list[MyData]:
        ...


class MyModel(Model):
    def embed(self) -> list[MyData]:
        ...


class Embedder(Protocol):
    def embed(self) -> list[Data]:
        ...


def modeller() -> Model:
    ...


def go(e: Embedder) -> None:
    pass


go(modeller())

```

pylance errors with:

```
Argument of type "Model" cannot be assigned to parameter "e" of type "Embedder" in function "go"
  "Model" is incompatible with protocol "Embedder"
    "embed" is an incompatible type
      Type "() -> list[MyData]" cannot be assigned to type "() -> list[Data]"
        Function return type "list[MyData]" is incompatible with type "list[Data]"
          "list[MyData]" is incompatible with "list[Data]" Pylance(reportArgumentType)
```

This is because list is invariant. Change to:

```python
class Embedder(Protocol):
    def embed(self) -> Sequence[Data]:
        ...
```

## References

- [Tagged unions aka sum types](https://mypy.readthedocs.io/en/stable/literal_types.html#tagged-unions)
- [python/typing issues](https://github.com/python/typing/issues)
- [typing-sig mailing list archives](https://mail.python.org/archives/list/typing-sig@python.org/)
