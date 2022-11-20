# systemctl

List services

```
systemctl list-units --type=service
```

Get status

```
systemctl status <service>
```

Inspect logs for service

```
sudo journalctl -u <service>
```
