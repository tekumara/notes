# vscode

List workspace profiles:

```
jq '.profileAssociations.workspaces' "$HOME/Library/Application Support/Code/User/globalStorage/storage.json"
```

List plugins running:

```
ps -Af | grep 'Code Helper (Plugin)' | grep -v grep | sed -E 's/.*\/Applications(.*)$/\/Applications\1/' | sort
```

## Troubleshooting

If vscode is slow, inspect Output -> Log(Window) to see if there are some unresponsive extensions. Try removing them. ([example](https://github.com/huizhougit/githd/issues/54))

If the follow link shortcut is Opt + Click then `Toggle Multi-Cursor Modifier` ([ref](https://github.com/microsoft/vscode/issues/36683))

CTRL+CMD+SPACE not showing the Emoji keyboard? It can work in some vscode windows but not others. Try FN+E instead, or `Edit - Emoji & Symbols` from the menu bar.
