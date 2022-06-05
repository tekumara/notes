# vscode

## Remote - SSH

Install the Remote - SSH extension.

`Remote-SSH: Connect to Host` will connect to any hosts defined in _~/.ssh/config_ and allow you to add new hosts.

If you're have trouble connecting, try the equivalent ssh command in the shell in verbose mode, eg: `ssh -vvv`.

When vscode connects to a host, it establishes dynamic port forwarding (`-D`) which acts as a SOCKS proxy server. Vscode then starts a remote server on the host and connects to it via the SOCKS proxy.

### Port forwarding

- User forwarded: added by the user in the Ports View, and forwarded via the SOCKS proxy.
- Auto forwarded: auto port forwarding when vscode sees "http://localhost:xxxx" in the terminal or debug console. See setting `remote.autoForwardPortsSource` in the release notes [here](https://github.com/microsoft/vscode-docs/blob/49f6cab2a0435a7704ebfc208852f23a880265f6/remote-release-notes/v1_54.md#port-forwarding-source-is-output) and [here](https://github.com/microsoft/vscode-docs/search?q=auto+port+forward).
- Statically forwarded: ports configured in _~/.ssh/config_ via the `LocalForward` statement.

### Extensions

Extensions, like the Python interpreter, need to be installed on the remote server before they can be used.

## Troubleshooting

If vscode is slow, inspect Output -> Log(Window) to see if there are some unresponsive extensions. Try removing them. ([example](https://github.com/huizhougit/githd/issues/54))

If the follow link shortcut is Opt + Click then `Toggle Multi-Cursor Modifier` ([ref](https://github.com/microsoft/vscode/issues/36683))

CTRL+CMD+SPACE not showing the Emoji keyboard? It can work in some vscode windows but not others. Try FN+E instead, or `Edit - Emoji & Symbols` from the menu bar.
