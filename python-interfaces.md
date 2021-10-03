# Python interfaces

## ABC

An Abstract Base Class (ABC) formalises the inspection of an object. An ABC describes how to inspect the type and properties of an object. This allows certain decisions to be made (eg: pattern matching) and enables type hinting and IDE auto-suggestion. See [PEP 3119](https://www.python.org/dev/peps/pep-3119/#rationale)

## Protocol

The `typing.Protocol` class enables structural subtyping. A protocol is an implicit base class. Any class that matches the protocol's defined members is considered to be a subclass for type analysis.

See the example [here](https://stackoverflow.com/a/50255847/149412)
