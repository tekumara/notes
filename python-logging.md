# python logging

Basic info level logging with time:

```python
import logging
logging.basicConfig(level=logging.INFO, format="%(threadName)s %(asctime)s %(levelname)s %(message)s")
```

To enable debug logging on the root logger:

```python
import logging
logging.basicConfig(level=logging.DEBUG)
```

pytest takes control of the root logger, so the above doesn't work. Instead run pytest with `--log-cli-level=DEBUG` or set the level on a non-root logger, eg:

```python
import logging
logger = logging.getLogger("s3fs")
logger.setLevel(logging.DEBUG)
```
