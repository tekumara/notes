# structlog

Default config:

```
>>> structlog.get_config()
{'processors': [<function merge_contextvars at 0x7f08d66799e0>, <function add_log_level at 0x7f08d64ff380>, <structlog.processors.StackInfoRenderer object at 0x7f08d5a31c60>, <function set_exc_info at 0x7f08d5e232e0>, <structlog.processors.TimeStamper object at 0x7f08d5e732c0>, <structlog.dev.ConsoleRenderer object at 0x7f08d5a09b90>], 'context_class': <class 'dict'>, 'wrapper_class': <class 'structlog._native.BoundLoggerFilteringAtNotset'>, 'logger_factory': <structlog._output.PrintLoggerFactory object at 0x7f08d5869a90>, 'cache_logger_on_first_use': False}
```

[structlog.\_native.BoundLoggerFilteringAtNotset](https://github.com/hynek/structlog/blob/ea7cac413fc8dae38af68cb4ea29b19581ebd413/src/structlog/_native.py#L234) will log all levels (ie: [min_level or higher](https://github.com/hynek/structlog/blob/ea7cac413fc8dae38af68cb4ea29b19581ebd413/src/structlog/_native.py#L78), where min_level = 0 aka `Notset`)
