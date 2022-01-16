# golang vscode debugging

vscode uses [delve](https://github.com/go-delve/delve) for debugging golang programs.

Open a file from the main package and start the debugging using Start Debugging (F5). Alternatively, from the Run and Debug view, create a Launch Package configuration.

See

- [Delve installation](https://github.com/go-delve/delve/tree/master/Documentation/installation)
- [Debugging Go code using VS Code](https://github.com/golang/vscode-go/blob/master/docs/debugging.md)

## remote debugging / headless

vscode also supports attaching to an existing process in:

- local mode: attach to a pid
- [remote mode](https://github.com/golang/vscode-go/blob/master/docs/debugging.md#remote-debugging)): attach to a port (can be local) when dlv is listening in headless mode

This is useful when you want to manually configure the program's environment, or pass it stdin.

To start delve in headless mode in the project directory:

```
dlv debug --headless --listen=:2345 --log
```

Alternatively you can [run dlv debug as a build task](https://github.com/microsoft/vscode-go/issues/219#issuecomment-449621513)), eg:

Arguments to the program can be passed by separating them with `--`, eg:

```
dlv debug --headless --listen=:12345 --log -- --help
```

In vscode, use a remote attach launch configuration in `launch.json`, eg:

```
        {
            "name": "Connect to external session",
            "type": "go",
            "debugAdapter": "dlv-dap", // `legacy` by default
            "request": "attach",
            "mode": "remote",
            "port": 12345,
            "host": "127.0.0.1", // can skip for localhost
            "substitutePath": [
                { "from": ${workspaceFolder}, "to": "/path/to/remote/workspace" },
                ...
            ]
        }
```

You'll see a warning popup:

```
'remote' mode with 'dlv-dap' debugAdapter must connect to an external `dlv --headless` server @ v1.7.3 or later.
```

This will appear even with later versions of dlv and can be ignored.

If the above doesn't work try [legacy mode](https://github.com/golang/vscode-go/blob/master/docs/debugging-legacy.md#remote-debugging)

## Failed to continue - bad access

On panic, debugging fails. This is a known issue, see [MacOS: cannot continue on panic #1371](https://github.com/go-delve/delve/issues/1371)
