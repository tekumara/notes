# Vscode

## Terminal

The integrated terminal will start in the project workspace, source any python virtualenvs, and inherit environment variables from vscode.

## Vscode vs IntelliJ

[Vscode can't open symbols in python dependencies](https://stackoverflow.com/questions/59450270/vscode-open-symbols-in-python-dependencies)

In vscode, when comparing changes in the git working tree to HEAD, there's no ability to compare individual lines between versions.

IntelliJ debugger evaluates expressions inline, which is rather nice. Vscode will show variable values when you hover over them.

## Tests

Command Shift P - Python: Discover Tests

## Debugging

To debug inside dependencies, add `"justMyCode": false` to the launch config.  
To avoid creating terminal windows every time you launch (the default) set `"console": "internalConsole"` in the launch config.

## Environment

VSCode and its integrated terminal will inherit environment variables from the process that starts VSCode. eg: if you set any `AWS_*` env vars in a shell and then start code, those will be available to your program when VSCode runs/debugs it.

## Refresh

If packages have been updated but Pylance hasn't picked that up yet, try renaming the file (does closing the file and opening it again work?)