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

Service logs (shows when the service was run)

```
journalctl -u <service>
```

Timer logs (shows when the timer started, **not** when it was triggered)

```
journalctl -u <service>.timer
```
