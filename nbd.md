# nbd

```
❯ nbd-client 127.0.0.1 10809 /dev/nbd0 -N device_10809
Negotiation: ..size = 4096MB
Error: Failed to setup device, check dmesg

Exiting.
```

use `sudo`

```
nbd: nbd0 already in use
```

Disconnect:

```
sudo nbd-client -d /dev/nbd0
```
