# vscode python debugging

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

To run scripts installed in the virtualenv, [explicitly add the venv's bin dir to the path](https://github.com/microsoft/vscode-python/issues/4300#issuecomment-1146749781):

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
      "env": { "PATH": "${workspaceFolder}/.venv/bin"}
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

There are two console modes:

- `"console": "integratedTerminal"` (default) starts a terminal window and runs the program there. Useful if you want to set up environment variables manually in advance.
- `"console": "internalConsole"` avoids creating terminal windows every time you launch

## Attach

Install [debugpy](https://github.com/microsoft/debugpy):

```
pip install debugpy
```

Run your program and wait for connection:

```
python -m debugpy --listen 62888 --wait-for-client <filename> | -m <module> [<arg>]...`
```

`<program>` can be a path to a _.py_ file or a console script, eg: _.venv/bin/myapp_ or a module.

To debug a test called `test_flow`:

```
python -m debugpy --listen 62888 --wait-for-client -m pytest -k test_flow
```

Connect to the debugger using an attach config:

```json
{
  "name": "Python: Remote Attach",
  "type": "python",
  "request": "attach",
  "connect": {
    "host": "localhost",
    "port": 62888
  },
  "pathMappings": [
    {
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "."
    }
  ],
  "justMyCode": false
}
```

## Breakpoint in file that does not exist

Make sure you are mapping the cwd of debugpy (ie: remote root) to your workspace.

eg: if running debugpy in a subdir of your workspace folder, use:

```json
            "pathMappings": [
                {
                    "localRoot": "${workspaceFolder}",
                    "remoteRoot": "../"
                }
            ],
```

## References

- [Python debugging in VS Code](https://code.visualstudio.com/docs/python/debugging)
- [Why the debug console uses tab for autocompletion selection](https://github.com/microsoft/vscode/issues/108439#issuecomment-871521843)
