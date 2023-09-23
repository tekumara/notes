# macos-sshd

To enable: System Settings -> Sharing, enable Remote Login

Configured in:

```
# openssh defaults
cat /etc/ssh/sshd_config

# Options set by macOS that differ from the OpenSSH defaults
cat /etc/ssh/sshd_config.d/100-macos.conf

```

PAM is and interactive password access is enabled by default.

To connect to another machine on the local network:

```
ssh username@machine.local
```

To clone a repo:

```
git clone git+ssh://username@machine.local/~/code/myrepo
```
