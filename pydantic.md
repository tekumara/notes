# pydantic

## Pre-process fields

To run `strip_currency_symbols` before the base validation:

```python
Money = Annotated[Decimal, BeforeValidator(strip_currency_symbols)]
```

## Custom type with before validator

See [Customizing validation with **get_pydantic_core_schema**](https://docs.pydantic.dev/latest/concepts/types/#customizing-validation-with-__get_pydantic_core_schema__), eg:

```python
import re
from decimal import Decimal
from typing import Any

from pydantic import GetCoreSchemaHandler
from pydantic_core import CoreSchema, core_schema


class Money(Decimal):
    currency_symbols = re.compile(r"[$€£]")

    def __repr__(self):
        return f"Currency({self})"

    @classmethod
    def strip_currency_symbols(cls, value: Any) -> Any:  # noqa: ANN401
        if isinstance(value, str):
            return re.sub(cls.currency_symbols, "", str(value))
        return value

    @classmethod
    def __get_pydantic_core_schema__(
        cls, _source_type: Any, _handler: GetCoreSchemaHandler  # noqa: ANN401
    ) -> CoreSchema:
        return core_schema.no_info_before_validator_function(cls.strip_currency_symbols, core_schema.decimal_schema())
```
