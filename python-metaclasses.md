# python metaclasses

## TypeError: metaclass conflict: the metaclass of a derived class must be a (non-strict) subclass of the metaclasses of all its bases

Python doesn't support multiple metaclasses on a type.

eg:

```python
from pydantic import BaseModel
from typing import Protocol

class Foo(Protocol):
    def foo(self, x: int) -> int:
        pass

class Model(Foo, BaseModel):
    a: int

---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)
Cell In[4], line 1
----> 1 class Model(Foo, BaseModel):
      2     a: int

TypeError: metaclass conflict: the metaclass of a derived class must be a (non-strict) subclass of the metaclasses of all its bases
```

This applies when combining any two classes that both have a metaclass, eg: TypedDict + Protocol, [msgspec.Struct + Protocol](https://github.com/jcrist/msgspec/issues/296#issuecomment-1416850398).

NB: dataclasses don't have this problem.
