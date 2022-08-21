# python mixins

Mixins are a way to compose behaviour at the class level via multiple inheritance. Unlike traditional inheritance, mixins don't express a specialization or `is-a` relationship, and you don't directly instantiate a mixin. Instead you compose a mixin into a concrete class, which is instantiated as an object that has the combined behaviour of that class and its mixins.

The alternative to mixins is object composition, which offers more encapsulation and avoids the dependency between super classes and sub classes that inheritance has.

Mixins are a solution to the circular dependency issue, but they aren't the only way to solve that. The other way is to avoid circular imports is to only use them when type checking, eg:

```python
if TYPE_CHECKING:
   import Noise
```

Or to use a [protocol](python-interfaces.md#protocol).
