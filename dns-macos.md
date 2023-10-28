# DNS on MacOS

DNS servers:

```
cat /etc/resolv.conf

scutil --dns
```

## Troubleshooting

Check DNS server: `scutil --dns`
To reset the DNS servers to their default for your ISP, turn wifi on and off again.

References

- [Big Sur reproducible DNS resolution issues](https://developer.apple.com/forums/thread/670856)
- [DNS not resolving on Mac OS X](https://apple.stackexchange.com/questions/26616/dns-not-resolving-on-mac-os-x)
