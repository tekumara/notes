# VS Code remote ssh

Install the Remote - SSH extension.

`Remote-SSH: Connect to Host` will connect to any hosts defined in _~/.ssh/config_ and allow you to add new hosts.

When vscode connects to a host, it establishes dynamic port forwarding (`-D`) which acts as a SOCKS proxy server. Vscode then starts a remote server on the host and connects to it via the SOCKS proxy.

## Port forwarding

- User forwarded: added by the user in the Ports View, and forwarded via the SOCKS proxy.
- Auto forwarded: auto port forwarding when vscode sees "http://localhost:xxxx" in the terminal or debug console. See setting `remote.autoForwardPortsSource` in the release notes [here](https://github.com/microsoft/vscode-docs/blob/49f6cab2a0435a7704ebfc208852f23a880265f6/remote-release-notes/v1_54.md#port-forwarding-source-is-output) and [here](https://github.com/microsoft/vscode-docs/search?q=auto+port+forward).
- Statically forwarded: ports configured in _~/.ssh/config_ via the `LocalForward` statement.

## Extensions

Extensions, like the Python interpreter, need to be installed on the remote server before they can be used.

## VS Code Server

When `remote.SSH.useLocalServer=true` (the default) VS Code Remote SSH will start a vscode-server process on the SSH host, eg:

```
ubuntu     13478       1  2 01:01 ?        00:00:11 /home/ubuntu/.vscode-server/bin/784b0177c56c607789f9638da7b6bf3230d47a8c/node /home/ubuntu/.vscode-server/bin/784b0177c56c607789f9638da7b6bf3230d47a8c/out/server-main.js --start-server --host=127.0.0.1 --accept-server-license-terms --enable-remote-auto-shutdown --port=0 --telemetry-level all --install-extension ms-python.python --install-extension ms-python.vscode-pylance --connection-token-file /home/ubuntu/.vscode-server/.784b0177c56c607789f9638da7b6bf3230d47a8c.toke
```

When a VS Code SSH window is closed, it will close its connection with the server. The server will wait up to [5 mins for new connections before shutting down](https://github.com/microsoft/vscode/blob/0656d21/src/vs/server/node/remoteExtensionHostAgentServer.ts#L590).

VS Code processes on the remote (eg: terminals) are child process of the vscode server process.

## Local server

https://github.com/microsoft/vscode-remote-release/wiki/Debugging-for-Remote-SSH

## Troubleshooting

If you're have trouble connecting, try the equivalent ssh command in the shell in verbose mode, eg: `ssh -vvv`.

### No SSH keys after reconnecting

If you get disconnected from your SSH session and reconnect and are not able to authenticate to github via SSH or other SSH hosts, try resetting SSH_AUTH_SOCK to the latest socket:

```
export SSH_AUTH_SOCK=$(ls -t /run/user/1001/vscode-ssh-auth-sock-* | head -1)
```

See [#7859](https://github.com/microsoft/vscode-remote-release/issues/7859).

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

### Stale user permissions

Modifying group membership of your user on the remote will not be reflected in the terminal until the vscode server restarts.

This is because vscode remote processes (eg: terminals) are child process of the vscode server, which persists after client window shutdown, see [above](#vs-code-server).

### Forwarding doesn't work

Check Output - Log (Shared):

```
[2022-09-11 21:49:55.485] [sharedprocess] [error] [remote-connection][Tunnel       ][661fd…][initial][127.0.0.1:56282] socketFactory.connect() failed or timed out. Error:
[2022-09-11 21:49:55.485] [sharedprocess] [error] Error: connect ECONNREFUSED 127.0.0.1:56282
    at __node_internal_captureLargerStackTrace (node:internal/errors:464:5)
    at __node_internal_exceptionWithHostPort (node:internal/errors:642:12)
    at TCPConnectWrap.afterConnect [as oncomplete] (node:net:1157:16)
[2022-09-11 21:49:55.485] [sharedprocess] [error] [uncaught exception in sharedProcess]: A system error occurred (connect ECONNREFUSED 127.0.0.1:56282): Error: connect ECONNREFUSED 127.0.0.1:56282
    at __node_internal_captureLargerStackTrace (node:internal/errors:464:5)
    at __node_internal_exceptionWithHostPort (node:internal/errors:642:12)
    at TCPConnectWrap.afterConnect [as oncomplete] (node:net:1157:16)
```

see [#7180](https://github.com/microsoft/vscode-remote-release/issues/7180)
