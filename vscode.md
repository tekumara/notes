# vscode

## Remote - SSH

Install the Remote - SSH extension.

`Remote-SSH: Connect to Host` will connect to any hosts defined in _~/.ssh/config_ and allow you to add new hosts.

If you're have trouble connecting, try the equivalent ssh command in the shell in verbose mode, eg: `ssh -vvv`.

When vscode connects to a host, it establishes dynamic port forwarding (`-D`) which acts as a SOCKS proxy server. Vscode then starts a remote server on the host and connects to it via the SOCKS proxy. 

### Port forwarding

- User forwarded: added by the user in the Ports View, and forwarded via the SOCKS proxy.
- Auto forwarded: auto forwarding from applications stared in the terminal.
- Statically forwarded: ports configured in _~/.ssh/config_ via the `LocalForward` statement.

### Extensions

Extensions, like the Python interpreter, need to be installed on the remote server before they can be used.

## Troubleshooting

If vscode is slow, inspect Output -> Log(Window) to see if there are some unresponsive extensions. Try removing them. ([example](https://github.com/huizhougit/githd/issues/54))
