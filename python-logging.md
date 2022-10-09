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

To disable [warnings](https://docs.python.org/3/library/warnings.html):

```
python -W ignore::DeprecationWarning
```

See also how to configure this for [pytest](https://docs.pytest.org/en/latest/how-to/capture-warnings.html#disabling-warnings-summary).
