# macOS networking

Routing tables:

```
netstat -rn
```

Internet sockets open by processes owner by current user:

```
lsof -i -P -n
```

Owned by any user:

```
sudo lsof -i -P -n
```

Run a program blocking all network access, eg: with curl

```
$ sandbox-exec -n no-network curl -vvv http://google.com
sandbox-exec: The no-network profile is deprecated and may not be secure
* Could not resolve host: google.com
* Closing connection
curl: (6) Could not resolve host: google.com
```

Config allow localhost access only:

```
; File: no-network-localhost-only.sb
; eg: sandbox-exec -f no-network-localhost-only.sb curl -vvv http://localhost
(version 1)
(debug deny) ; Log denials to Console.app under sandboxd reports for debugging

(allow default) ; Start by allowing most non-network operations by default

; --- Network Rules ---

; Explicitly ALLOW outgoing network connections ONLY to localhost IPs (any port)
(allow network-outbound(remote ip "localhost:*"))

; Explicitly DENY all other outgoing network connections.
; Because the specific 'allow' rules for localhost are defined above,
; this rule will effectively block any outbound connection attempt that
; is NOT directed to 127.0.0.1 or ::1.
(deny network-outbound)
```

## Troubleshooting

### Service not listening on 127.0.0.1 but listening on \[::1\]

Check:

```
❯ lsof -i -P -n | grep LISTEN | grep 6333
Code\x20H  2866 tekumara   35u  IPv4 0xf7bb05b97fb537c3      0t0  TCP 127.0.0.1:6333 (LISTEN)
com.docke 40002 tekumara  182u  IPv6 0xf7bb05be4bcbb5db      0t0  TCP *:6333 (LISTEN)
```

VS Code is taking the IPv4 port.
