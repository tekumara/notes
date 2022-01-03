# ubuntu motd

To run the motd files:
```
sudo run-parts /etc/update-motd.d/
```

Note this won't update `/run/motd.dynamic` which is displayed by `pam_motd` on login (see `man pam_motd`).

```
$ cat /etc/pam.d/login | grep motd
# This includes a dynamically generated part from /run/motd.dynamic
# and a static (admin-editable) part from /etc/motd.
session    optional   pam_motd.so motd=/run/motd.dynamic
session    optional   pam_motd.so noupdate

$ cat /etc/pam.d/sshd | grep motd
# This includes a dynamically generated part from /run/motd.dynamic
# and a static (admin-editable) part from /etc/motd.
session    optional   pam_motd.so motd=/run/motd.dynamic
session    optional   pam_motd.so noupdate
```

On login/ssh `pam_motd` will execute run-parts as root and pipe that to `/run/motd.dynamic.new`. If there are no errors, it will rename `/run/motd.dynamic.new` -> `/run/motd.dynamic`.

If `/run/motd.dynamic` hasn't been updated it may be because of errors in your motd scripts. Check with:
```
sudo run-parts /etc/update-motd.d/ > /dev/null
```

For the history and evolution of the motd, see https://ownyourbits.com/2017/04/05/customize-your-motd-login-message-in-debian-and-ubuntu/
