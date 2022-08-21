# ssh forwarding

Forward port 9000 on the local machine to port `5432` on `beelitz.devel`.

```
ssh -L 9000:localhost:5432 beelitz.devel
```

Forward port 8080 on the local machine to port `5432` on `ip-10-97-37-16.ec2.internal` accessed via beelitz.devel:

```
ssh -L 8080:ip-10-97-37-16.ec2.internal:5432 beelitz.devel
```

Use `-N` to avoid getting a shell on the remote, and `-Nf` to fork into the background and remain once the host shell exits. 

```
ssh -N -L 8080:ip-10-97-37-16.ec2.internal:5432 beelitz.devel
```

-N to avoid getting a shell on the remote, and -f to move the process to the background without losing it if you close the shell.

See [more examples](http://blog.trackets.com/2014/05/17/ssh-tunnel-local-and-remote-port-forwarding-explained-with-examples.html)

## SOCKS

Start a SOCKS server on localhost:48888

```
ssh -D 48888 hostname
```

## Using a SOCKS server in Chrome extension

1. Install the [Proxy SwitchyOmega Chrome extension](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif?hl=en)
1. Within SwitchyOmega create a rule for using the proxy
1. From the SwitchyOmega icon on your Extension bar, choose auto switch

## Troubleshooting

> {{channel 3: open failed: connect failed: Connection refused}}

The destination host being forwarded to refused the connection
