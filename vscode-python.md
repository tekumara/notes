# Vscode

## Terminal

The integrated terminal will start in the project workspace, source any python virtualenvs, and inherit environment variables from vscode.

## Tests

Command Shift P - Python: Discover Tests

## Debugging

To debug inside dependencies, add `"justMyCode": false` to the launch config in `launch.json`. To enable this for all tests:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "tests",
      "type": "python",
      "request": "test",
      "justMyCode": false
    }
  ]
}
```

To avoid creating terminal windows every time you launch (the default) set `"console": "internalConsole"` in the launch config.

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

## Environment

VSCode and its integrated terminal will inherit environment variables from the process that starts VSCode. eg: if you set any `AWS_*` env vars in a shell and then start code, those will be available to your program when VSCode runs/debugs it.

To disable this, set `terminal.integrated.inheritEnv` to false.

## Refresh

If packages have been updated but Pylance hasn't picked that up yet, try renaming the file (does closing the file and opening it again work?)

## Multi-Cursor

Option+Click will allow you to set multiple cursor points. This can be changed to Cmd+Click via _Selection -> Switch to Cmd+Click for Multi-Cursor_

## Vscode vs IntelliJ

[Vscode can't open symbols in python dependencies](https://stackoverflow.com/questions/59450270/vscode-open-symbols-in-python-dependencies)

In vscode, when comparing changes in the git working tree to HEAD, there's no ability to compare individual lines between versions.

IntelliJ debugger evaluates expressions inline, which is rather nice. Vscode will show variable values when you hover over them.

Vscode file rename doesn't do a git rename (once committed git will identify the rename), and doesn't update any references to the renamed file.

Intellij can move functions, and their imports, between files. Vscode can't.

Intellij will parse notebook code, find errors, and has go to definition. Vscode doesn't have any python language support for notebook cells.
