# systemctl

List active services

```
systemctl list-units --type=service
```

List active timers

```
systemctl list-units --type=timer
```

Get status of timer

```
systemctl status <service>.timer
```

Get status of service

```
systemctl status <service>
```

Restart the aws-ubuntu-eni-helper service now:

```
sudo systemctl restart aws-ubuntu-eni-helper
```

Service logs (shows when the service was run)

```
sudo journalctl -u <service>
```

Timer logs (shows when the timer started, **not** when it was triggered)

```
sudo journalctl -u <service>.timer
```

Show errors from the most recent boot:

```
sudo journalctl -b -p err
```

[Run generators and reload unit files](https://www.freedesktop.org/software/systemd/man/systemctl.html#daemon-reload)

```
sudo systemctl daemon-reload
```

Systemctl's load:

```
sudo tail -f /var/log/syslog | grep systemd
```

List dependencies `mnt-fsx.mount` is after, ie: dependencies that run *before* `mnt-fsx.mount`

```
systemctl list-dependencies --after mnt-fsx.mount
```

List dependencies `network-online.target` is before

```
systemctl list-dependencies --before network-online.target
```

See [Network Configuration Synchronization Points](https://systemd.io/NETWORK_ONLINE/)
