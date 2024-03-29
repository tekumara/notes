# Python interfaces

## ABC

An Abstract Base Class (ABC) formalises the inspection of an object. An ABC describes how to inspect the type and properties of an object. This allows certain decisions to be made (eg: pattern matching) and enables type hinting and IDE auto-suggestion. See [PEP 3119](https://www.python.org/dev/peps/pep-3119/#rationale)

## Protocol

The `typing.Protocol` class enables structural subtyping. A protocol is an implicit base class. Any class that matches the protocol's defined members is considered to be a subclass for type analysis.

See the example [here](https://stackoverflow.com/a/50255847/149412)

Because it structural, rather than nominal, an explicit import is not needed, and so it can be used to [break circular import errors](https://pythontest.com/fix-circular-import-python-typing-protocol/), eg:

```
ImportError: cannot import name 'TransactionSet' from partially initialized module 'txgenerator.models' (most likely due to a circular import)
```

See

- [mypy - Protocols and structural subtyping](https://mypy.readthedocs.io/en/stable/protocols.html)
- [Protocols](https://typing.readthedocs.io/en/latest/spec/protocol.html)
