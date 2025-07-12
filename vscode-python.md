# Vscode

## Terminal

The integrated terminal will start in the project workspace, source any python virtualenvs, and inherit environment variables from vscode.

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

Vscode file rename doesn't do a git rename (once committed git will identify the rename).

Intellij can move functions, and their imports, between files. Vscode can't.

Intellij will parse notebook code, find errors, and has go to definition. Vscode doesn't have any python language support for notebook cells.

## Python interpreters

To change interpreter select _Python: Select Interpreter_. If vscode doesn't switch to your interpreter, check _Output -> Python Language Server_ for errors.

If the interpreter selection fails, enable debug logging via `Developer: Set Log Level`

## Testing

To configure pytest use _pyproject.toml_ or [vscode configuration options](https://code.visualstudio.com/docs/python/testing#_pytest-configuration-settings):

eg: to run pytest against _tests/_ and stream stdout:

```
    "python.testing.pytestArgs": [
        "tests",
        "-s"
    ],
```

## Trouble shooting Pylance

In Settings set `"python.analysis.logLevel": "Trace"` to get more detailed logs in `Output - Python Language Server`.

### reportMissingImports

eg:

> Import "boto3" could not be resolved Pylance (reportMissingImports)

This can happen when

- the selected python interpreter in VS Code is not pointing at the right virtualenv, and so it cannot find the installed package (eg: boto3).
- the imports are for an egg link

### .venv not shown in list of python interpreters and cannot be manually selected

See [#4361](https://github.com/microsoft/pylance-release/issues/4361).

Try reloading the window first.

NB: To force Pylance to use the interpreter in the virtualenv, set `.venvPath` and `.venv` in the pyright config.
