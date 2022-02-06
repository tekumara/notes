# vscode python debugging

To avoid creating terminal windows every time you launch (the default) set `"console": "internalConsole"` in the launch config.

To debug inside dependencies, add `"justMyCode": false` to the launch config in _launch.json_. To enable this for all tests:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "testing",
      "type": "python",
      "request": "launch",
      "purpose": ["debug-test"],
      "justMyCode": false
    }
  ]
}
```

To run a fastapi/uvicorn app

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "fastapi",
      "type": "python",
      "request": "launch",
      "env": { "API_VERSION": "vscode.debug" },
      "program": "venv/bin/uvicorn",
      "args": ["app.main:app", "--reload"],
      "console": "internalConsole"
    }
  ]
}
```

## Attach

Install [debugpy](https://github.com/microsoft/debugpy):

```
pip install debugpy
```

Run your program and wait for connection:

```
python -m debugpy --listen 62888 --wait-for-client myapp/main.py arg`
```

Connect to the debugger using an attach config:

```
{
    "name": "Python: Attach to 62888",
    "type": "python",
    "request": "attach",
    "connect":{
    "host": "localhost",
    "port": 62888
    }
},
```

## References

- [Python debugging in VS Code](https://code.visualstudio.com/docs/python/debugging)
- [Why the debug console uses tab for autocompletion selection](https://github.com/microsoft/vscode/issues/108439#issuecomment-871521843)
