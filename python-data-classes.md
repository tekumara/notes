# python data classes

"mutable namedtuples with defaults"

mutability is good when you want to build up a complex datastructure because you can do it incrementally (ie: like the builder pattern)

dataclasses can also be immutable, eg:

```
@dataclass(frozen=True)
class Magic:
```

## Alternative

Force a class to only have named args.

```python
class SparkSubmitArgs:
    def __init__(self, *pos_catcher, name: str, ...):
        self.name = name
        ...
```
