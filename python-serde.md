# python serde

Features:

- serde dataclass <-> dict
- serde dataclass <-> json bytes
- nested dataclass support
- field renames
- basic validation
- enum support
- custom transforms
- date support
- default values

## dataclasses

validates field names, not types (to confirm)
non-nested <-> dict

## orjson

serde dict <-> json bytes
serialises dataclasses, but doesn't deserialise them from json bytes
