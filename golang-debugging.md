# golang debugging

## vscode

vscode uses delve for debugging golang programs.

[Debugging Go code using VS Code](https://github.com/golang/vscode-go/blob/master/docs/debugging.md)

## cli requiring standard input

Start delve in headless mode in the project directory (or [run as a build task](https://github.com/microsoft/vscode-go/issues/219#issuecomment-449621513)), eg:

```
dlv debug --headless --listen=:2345 --log --api-version=2
```

Arguments to the program can be passed by separating them with `--`, eg:

```
dlv debug --headless --listen=:2345 --log --api-version=2 -- --help
```

In vscode, use a remote attach launch configuration in `launch.json`, eg:

```
        {
            "name": "Remote attach",
            "type": "go",
            "request": "attach",
            "mode": "remote",
            "remotePath": "${workspaceFolder}",
            "port": 2345,
            "host": "127.0.0.1"
        }
```

## Failed to continue - bad access

On panic, debugging fails. This is a known issue, see [MacOS: cannot continue on panic #1371](https://github.com/go-delve/delve/issues/1371)
