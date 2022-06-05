# python logging

Basic info level logging with time:

```python
import logging
logging.basicConfig(level=logging.INFO, format="%(threadName)s %(asctime)s %(levelname)s %(message)s")
```
