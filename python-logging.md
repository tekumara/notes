# python logging

To create a logger:

```python
import logging
logger = logging.getLogger(__name__)
```

By default logging output goes to stderr, with no formatting, for WARNING or above (see the [handler of last resort](https://docs.python.org/3/library/logging.html#logging.lastResort)).

eg:

```shell
❯ python -c 'import logging;logger = logging.getLogger(__name__);logger.warning("foo")' > /dev/null
foo
```

To output info level and above to stderr with timestamps etc. configure the root handler using [basicConfig](https://docs.python.org/3/library/logging.html#logging.basicConfig):

```python
import logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s %(threadName)s %(message)s")
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

Or use the [PYTHONWARNINGS](https://docs.python.org/3/using/cmdline.html#envvar-PYTHONWARNINGS) env var:

```
PYTHONWARNINGS=once python ..
```

See also how to configure this for [pytest](https://docs.pytest.org/en/latest/how-to/capture-warnings.html#disabling-warnings-summary).
