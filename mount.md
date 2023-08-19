# mount

Mount units may either be configured via unit files, or via `systemd-fstab-generator` which generates them from _/etc/fstab_ automatically. Systemd generators are run before unit files are loaded during bootup and [config reload](https://www.freedesktop.org/software/systemd/man/systemctl.html#daemon-reload), ie: `sudo systemctl daemon-reload`.

## network mounts

From the [systemd.mount man page](https://www.freedesktop.org/software/systemd/man/systemd.mount.html):

> Network mount units automatically acquire After= dependencies on remote-fs-pre.target, network.target and network-online.target, and gain a Before= dependency on remote-fs.target unless nofail mount option is set. Towards the latter a Wants= unit is added as well.
