# macOS networking

Routing tables:

```
netstat -rn
```

## Troubleshooting

### Service not listening on 127.0.0.1 but listening on [::1]

Check:

```
❯ lsof -i -P -n | grep LISTEN | grep 6333
Code\x20H  2866 tekumara   35u  IPv4 0xf7bb05b97fb537c3      0t0  TCP 127.0.0.1:6333 (LISTEN)
com.docke 40002 tekumara  182u  IPv6 0xf7bb05be4bcbb5db      0t0  TCP *:6333 (LISTEN)
```

VS Code is taking the IPv4 port.
