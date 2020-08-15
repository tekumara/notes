# Vscode

## Keyboard shortcuts (default)

https://code.visualstudio.com/docs/getstarted/keybindings

Show Command Palette CMD SHIFT p
Navigate forward/backwards CTRL - / CTRL SHIFT -
Switch file pane CTRL TAB / CTRL SHIFT TAB
Switch/toggle terminal pane CTRL ~
Search all files SHIFT CMD f
Show explorer CMD SHIFT e
Show source control CTRL SHIFT g
Switch windows CTRL w
Format document SHIFT OPT f

Go to file CMD p
Go to Symbol in Workspace CMD t
Go to line CTRL g

Toggle word wrap OPT z
Quick fix CMD .

Debug
Step Over F10
Step Into F11

Column select Shift+Option+Cmd and arrow keys
Column select (mouse) Click on start position, Shift+Option and click/drag to end position

## Keyboard shortcuts (IntelliJ)

Format document OPT CMD l

Go to file SHIFT CMD o
Go to Symbol in Workspace  CMD o
Navigate forward/backwards CMD OPT right / CMD OPT left

## Terminal

The integrated terminal will start in the project workspace, source any python virtualenvs, and inherits environment variables from vscode.

## Vscode vs IntelliJ

[Vscode can't open symbols in python dependencies](https://stackoverflow.com/questions/59450270/vscode-open-symbols-in-python-dependencies)

In vscode, when comparing changes in the git working tree to HEAD, there's no ability to compare individual lines between versions.

IntelliJ debugger evaluates expressions inline, which is rather nice.

## Tests

Command Shift P - Python: Discover Tests

## Debugging

To debug inside dependencies, add `"justMyCode": false` to the launch config.
To avoid creating terminal windows everytime you launch (the default) set `"console": "internalConsole"` in the launch config.
