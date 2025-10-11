# squid

```
brew install squid
vim /opt/homebrew/etc/squid.conf
```

To see config docs:

```
less /opt/homebrew/etc/squid.conf.documented
```

Var:

```
/opt/homebrew/var/cache/squid/
```

Access log:

```
tail -f /opt/homebrew/var/logs/access.log
```

Store everything, regardless of whether it has an etag or last modified header:

```
refresh_pattern .		60	20%	4320 store-stale
```

## SSL bump

Initialise SSL db:

```
/opt/homebrew/Cellar/squid/7.1/libexec/security_file_certgen -c -s /opt/homebrew/var/cache/squid/ssl_db -M 4MB
Initialization SSL db...
Done
```

Create pem:

```
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /opt/homebrew/etc/squid-cert/private.pem -out /opt/homebrew/etc/squid-cert/private.pem
```

Configure in squid.conf:

```
http_port 3128 ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB cert=/opt/homebrew/etc/squid-cert/private.pem key=/opt/homebrew/etc/squid-cert/private.pem

ssl_bump server-first all
```

## Troubleshooting

```
FATAL: The sslcrtd_program helpers are crashing too rapidly, need help!
```

Init SSL db (see above).

```
2025/08/17 21:46:35| ERROR: TLS failure: failed to allocate handle: error:0A0C0102:SSL routines::passed a null parameter
    current master transaction: master53
2025/08/17 21:46:35| ERROR: client https start failed to allocate handle: error:0A0C0102:SSL routines::passed a null parameter
    current master transaction: master53
2025/08/17 21:46:35| ERROR: could not create TLS server context for conn17 local=[::1]:4128 remote=[::1]:52438 FD 14 flags=1
    current master transaction: master53
```

Must configure ssl_bump in squid.conf file correctly, see above.
