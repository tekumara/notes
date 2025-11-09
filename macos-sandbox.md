# macos sandbox (seatbelt)

Run a program blocking all network access, eg: with curl

```
$ sandbox-exec -n no-network curl -vvv http://google.com
sandbox-exec: The no-network profile is deprecated and may not be secure
* Could not resolve host: google.com
* Closing connection
curl: (6) Could not resolve host: google.com
```

Profile to allow localhost access only:

```
; File: no-network-localhost-only.sb
; eg: sandbox-exec -f no-network-localhost-only.sb curl -vvv http://localhost
(version 1)
(debug deny) ; Log denials to Console.app under Sandbox for debugging

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

Debugging:

```
(version 1)
(debug deny) ; Log denials to Console.app under Sandbox for debugging
(allow default) ; Start by allowing most non-network operations by default
```

System profiles can be found in _/System/Library/Sandbox/Profiles_

## References

- [Chromium - The Mac Sandbox](https://chromium.googlesource.com/chromium/src/+/master/sandbox/mac/)
