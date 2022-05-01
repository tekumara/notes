# VS Code remote ssh

## Troubleshooting

### No SSH keys after reconnecting

If you get disconnected from your SSH session and reconnect and are not able to authenticate to github via SSH or other SSH hosts, try reconnecting again using Reload Window. If that fails, reset SSH_AUTH_SOCK to the latest socket:

```
export SSH_AUTH_SOCK=$(ls -t /run/user/1001/vscode-ssh-auth-sock-* | head -1)
```

### No browser popups after reconnecting

Each time the VS Code window is reloaded a new IPC socket is created. If you leave a background processes running and then exit VS Code (or reconnect) it with have a stale `VSCODE_IPC_HOOK_CLI` variable/IPC socket and won't be able to open the browser on your host.

To fix, update `VSCODE_IPC_HOOK_CLI` in the process's environment to the latest socket, eg:

- for a process running on the command line:

  ```
  export VSCODE_IPC_HOOK_CLI=$(ls -t /run/user/1001/vscode-ipc-*.sock | head -1)
  ```

- for a jupyter notebook, run this in a notebook cell:

  ```
  sock = !ls -t /run/user/1001/vscode-ipc-*.sock | head -1
  sock = sock[0]
  %env VSCODE_IPC_HOOK_CLI=$sock
  ```
