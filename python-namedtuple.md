# Python class vs dict vs namedtuple

TypedDict is a plain dictionary with type hints. ie: it's mutable
NamedTuple is immutable

"Dataclasses don't use __slots__.
They are bigger, slower, and more complex than NamedTuples.
But they offer mutability and customizability." 
[ref](https://twitter.com/raymondh/status/1175992038879219712?s=20)

## [R0903(too-few-public-methods), Mordor]

The error basically says that classes aren't meant to just store data, as you're basically treating the class as a dictionary. Classes should have at least a few methods to operate on the data that they hold.

## namedtuple vs dict

- namedtupled are faster than a dict and use less memory

```
import sys, collections
                                                    # Python 3.6.3 Mac OS X
sys.getsizeof(dict())                               # 240 bytes
sys.getsizeof(tuple())                              # 48 bytes
tuple_n = collections.namedtuple("Named",[])
sys.getsizeof(tuple_n())                            # 48 bytes
```

- has an order (like OrderedDict)
- can use type hints with a namedtuple
- `mynamedtuple.fieldname` is prettier than `mydict['fieldname']`
- namedtuples are immutable
