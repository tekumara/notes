# mount

```
❯ cat /etc/fstab | grep fsx
fs-12345678901234567.fsx.us-east-1.amazonaws.com:/fsx /mnt/fsx nfs nfsvers=4.1,defaults 0 0
```

## Troubleshooting

### Logs

Check sys log:

```
sudo rg -C5 'Failed to mount' /var/log/syslog*
```

### mount.nfs: Network is unreachable

Check for `systemd-network` messages around the same time as mounting:

```
sudo grep -E "DHCP lease lost|fsx" /var/log/syslog
May 22 04:20:21 ip-10-97-36-149 systemd[1]: Mounting /mnt/fsx...
May 22 04:20:21 ip-10-97-36-149 systemd-networkd[959]: ens5: DHCP lease lost
May 22 04:20:21 ip-10-97-36-149 systemd[1]: mnt-fsx.mount: Mount process exited, code=exited, status=32/n/a
May 22 04:20:21 ip-10-97-36-149 systemd[1]: mnt-fsx.mount: Failed with result 'exit-code'.
May 22 04:20:21 ip-10-97-36-149 systemd[1]: Failed to mount /mnt/fsx.
```

Or:

```
sudo grep -E "systemd-networkd|fsx|eni-helper" /var/log/syslog
```

```
❯ sudo journalctl -b -u mnt-fsx.mount -u network-online.target
-- Logs begin at Thu 2023-04-06 10:33:08 UTC, end at Sat 2023-04-22 06:26:59 UTC. --
Apr 22 06:05:05 ip-10-97-36-126 systemd[1]: Reached target Network is Online.
Apr 22 06:05:06 ip-10-97-36-126 systemd[1]: Mounting /mnt/fsx...
Apr 22 06:05:07 ip-10-97-36-126 mount[821]: mount.nfs: Network is unreachable
Apr 22 06:05:07 ip-10-97-36-126 systemd[1]: mnt-fsx.mount: Mount process exited, code=exited, status=32/n/a
Apr 22 06:05:07 ip-10-97-36-126 systemd[1]: mnt-fsx.mount: Failed with result 'exit-code'.
Apr 22 06:05:07 ip-10-97-36-126 systemd[1]: Failed to mount /mnt/fsx.
```

Or

```
sudo journalctl -b -u mnt-fsx.mount -u network-online.target -u aws-ubuntu-eni-helper.service | cat
```

Full syslog:

```
May 22 04:20:21 ip-10-97-36-149 systemd[1]: Started Hostname Service.
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: DEBUG:netplan generated networkd configuration changed, reloading networkd
May 22 04:20:21 ip-10-97-36-149 systemd[1]: Reloading.
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: DEBUG:ens5 not found in {}
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: DEBUG:Merged config:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: network:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:   ethernets:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:     ens5:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:       dhcp4: true
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:       dhcp6: false
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:       match:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:         macaddress: 0e:87:45:44:11:33
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:       set-name: ens5
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:   version: 2
May 22 04:20:21 ip-10-97-36-149 systemd[1]: Started OpenBSD Secure Shell server.
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: DEBUG:no netplan generated NM configuration exists
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: DEBUG:ens5 not found in {}
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: DEBUG:Merged config:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: network:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:   ethernets:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:     ens5:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:       dhcp4: true
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:       dhcp6: false
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:       match:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:         macaddress: 0e:87:45:44:11:33
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:       set-name: ens5
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:   version: 2
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: DEBUG:Skipping correctly named interface: ens5
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: DEBUG:Link changes: {}
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: DEBUG:netplan triggering .link rules for lo
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: DEBUG:netplan triggering .link rules for ens5
May 22 04:20:21 ip-10-97-36-149 kernel: [   28.153298] NFS: Registering the id_resolver key type
May 22 04:20:21 ip-10-97-36-149 kernel: [   28.153309] Key type id_resolver registered
May 22 04:20:21 ip-10-97-36-149 kernel: [   28.153310] Key type id_legacy registered
May 22 04:20:21 ip-10-97-36-149 containerd[1072]: time="2023-05-22T04:20:21Z" level=warning msg="containerd config version `1` has been deprecated and will be removed in containerd v2.0, please switch to version `2`, see https://github.com/containerd/containerd/blob/main/docs/PLUGINS.md#version-header "
May 22 04:20:21 ip-10-97-36-149 containerd[1072]: time="2023-05-22T04:20:21.775316252Z" level=info msg="starting containerd" revision=3dce8eb055cbb6872793272b4f20ed16117344f8 version=1.6.21
May 22 04:20:21 ip-10-97-36-149 netplan[1157]: starting new processing pass
May 22 04:20:21 ip-10-97-36-149 netplan[1157]: We have some netdefs, pass them through a final round of validation
May 22 04:20:21 ip-10-97-36-149 netplan[1157]: ens5: setting default backend to 1
May 22 04:20:21 ip-10-97-36-149 netplan[1157]: Configuration is valid
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: DEBUG:ens5 not found in {}
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: DEBUG:Merged config:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]: network:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:   ethernets:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:     ens5:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:       dhcp4: true
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:       dhcp6: false
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:       match:
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:         macaddress: 0e:87:45:44:11:33
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:       set-name: ens5
May 22 04:20:21 ip-10-97-36-149 aws-ubuntu-eni-helper.sh[1157]:   version: 2
May 22 04:20:21 ip-10-97-36-149 systemd-networkd[959]: ens5: Re-configuring with /run/systemd/network/10-netplan-ens5.network
May 22 04:20:21 ip-10-97-36-149 systemd-networkd[959]: ens5: DHCP lease lost
May 22 04:20:21 ip-10-97-36-149 containerd[1072]: time="2023-05-22T04:20:21.793806726Z" level=info msg="loading plugin \"io.containerd.content.v1.content\"..." type=io.containerd.content.v1
May 22 04:20:21 ip-10-97-36-149 containerd[1072]: time="2023-05-22T04:20:21.794270728Z" level=info msg="loading plugin \"io.containerd.snapshotter.v1.aufs\"..." type=io.containerd.snapshotter.v1
May 22 04:20:21 ip-10-97-36-149 mount[1001]: mount.nfs: Network is unreachable
May 22 04:20:21 ip-10-97-36-149 systemd[1]: mnt-fsx.mount: Mount process exited, code=exited, status=32/n/a
May 22 04:20:21 ip-10-97-36-149 systemd[1]: mnt-fsx.mount: Failed with result 'exit-code'.
May 22 04:20:21 ip-10-97-36-149 systemd[1]: Failed to mount /mnt/fsx.
May 22 04:20:21 ip-10-97-36-149 systemd[1]: Dependency failed for Remote File Systems.
May 22 04:20:21 ip-10-97-36-149 systemd[1]: remote-fs.target: Job remote-fs.target/start failed with result 'dependency'.
```

#### systemd units

See _/opt/eni/aws-ubuntu-eni-helper.sh_

```
❯ cat /lib/systemd/system/aws-ubuntu-eni-helper.service
[Unit]
Description=Setup Ubuntu Secondary ENI Helper
After=network.target

[Service]
Type=oneshot
ExecStart=/opt/eni/aws-ubuntu-eni-helper.sh
RemainAfterExit=true
StandardOutput=journal

[Install]
WantedBy=multi-user.target
```

```
❯ systemctl cat mnt-fsx.mount
# /run/systemd/generator/mnt-fsx.mount
# Automatically generated by systemd-fstab-generator

[Unit]
Documentation=man:fstab(5) man:systemd-fstab-generator(8)
SourcePath=/etc/fstab
Before=remote-fs.target

[Mount]
Where=/mnt/fsx
What=fs-12345678901234567.fsx.us-east-1.amazonaws.com:/fsx
Type=nfs
Options=nfsvers=4.1
```

```
❯ systemctl list-dependencies mnt-fsx.mount
mnt-fsx.mount
● ├─-.mount
● ├─system.slice
● └─network-online.target
●   └─systemd-networkd-wait-online.service
```
