# ubuntu motd

## MOTD

sshd in Ubuntu uses the dynamically linked [pam_motd](http://manpages.ubuntu.com/manpages/focal/man8/pam_motd.8.html) module to display the motd on login.

This behaviour is configured in _/etc/pam.d/sshd_:

```
# generate the dynamic motd (see below), and then display _/run/motd.dynamic_
session    optional   pam_motd.so motd=/run/motd.dynamic

# do not generate the dynamic motd, and display the default motd (ie: /etc/motd)
session    optional   pam_motd.so noupdate
```

NB:

- sshd can print the contents of _/etc/motd_ independently of `pam_motd`. This behaviour is triggered when `PrintMotd` is enabled. On Ubuntu, sshd is pam enabled and so the distro sets `PrintMotd No` in `/etc/ssh/sshd_config` to avoid _/etc/motd_ being printed twice (once by sshd, and again by pam_motd).
- _/etc/pam.d/login_ defines a similar configuration, but for use by the `login` program rather than `sshd`.

## Dynamic MOTD

Debian has a patched version of `pam_motd` which dynamically assembles the motd from scripts at login.

These scripts are located in _/etc/update-motd.d/_. On login, the patch executes run-parts as root and pipes that to the hardcoded location _/run/motd.dynamic.new_, ie:

```
sh -c /usr/bin/env -i PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin run-parts --lsbsysinit /etc/update-motd.d > /run/motd.dynamic.new
```

If there are no errors, it will then rename `/run/motd.dynamic.new` -> `/run/motd.dynamic`. Regardless of any errors, the patch will then display the motd defined in the pam config (see above).

To manually execute the motd scripts:

```
sudo run-parts /etc/update-motd.d/
```

## Gotchas

If `/run/motd.dynamic` hasn't been updated it may be because of errors in your motd scripts. Manually run them and check the exit code.

To detect when the dynamic motd is opened:

```
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_openat { printf("%d\t%s\t%d\t%d\t%s\n", pid, comm, args->flags, args->mode, str(args->filename)); }' | grep motd.dynamic
```

The motd doesn't show on multiplexed ssh connections, only on the "first" session that also does the authentication.

## References

- [pam_motd.c](https://github.com/lminux-pam/linux-pam/blob/master/modules/pam_motd/pam_motd.c). The unpatched upstream version.
- [Debian motd wiki](https://wiki.debian.org/motd) and the [update-motd](http://manpages.ubuntu.com/manpages/focal/man5/update-motd.5.html) manpage describes the dynamic motd behaviour/
- [update-motd.patch](https://github.com/pld-linux/pam/blob/587b47b56e6b85f4459dd6a0d7fd42498792444b/update-motd.patch) is a copy of the pam_motd patch that implements the dynamic update-motd behaviour.
- See [Customize your MOTD login message in Debian and Ubuntu](https://ownyourbits.com/2017/04/05/customize-your-motd-login-message-in-debian-and-ubuntu/) for the history and evolution of the motd.
- See [ArchLinux's PAM wiki](https://wiki.archlinux.org/title/PAM) for an overview of PAM.
