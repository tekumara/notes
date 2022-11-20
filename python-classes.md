# python classes

```python
class Dog:

    kind = 'canine'         # class variable shared by all instances

    def __init__(self, name):
        self.name = name    # instance variable unique to each instance
```

```python
"kind" in dir(Dog) # True
"kind" in dir(Dog("casper")) # True
"name" in dir(Dog("casper")) # True
"name" in dir(Dog) # False
```

With annotations (see PEP 526](https://www.python.org/dev/peps/pep-0526/#class-and-instance-variable-annotations)):

```python
class BasicStarship:
    captain: str = 'Picard'               # "instance" variable, but because it has a default appears at class level
    damage: int                           # instance variable without default
    stats: ClassVar[Dict[str, int]] = {}  # class variable
```

## **init**

If you override the `__init__` method of a superclass, and you want it to be called, you need to do that explicitly, eg:
`super().__init__(...)`

If
