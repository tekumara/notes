# sshd

## Install

Install (ubuntu):

```
sudo apt install openssh-server
```

Config in */etc/ssh/sshd_config*. The commented out lines indicate what the default is, eg: `#PubkeyAuthentication yes` means PubkeyAuthentication is on.

To see config options: `man sshd_config`

To enable login via public key:

```
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
```

Restart after changing config: `sudo systemctl restart sshd.service`

To enable verbose logging:

```
sudo sed -i 's/#LogLevel INFO/LogLevel VERBOSE/' /etc/ssh/sshd_config
```

To disable password login for a user, so they must use a publickey, add the following ([ref](https://serverfault.com/a/285844/126276)):

```
Match User david-bowie
    PasswordAuthentication no
```

Or disable the user password during creation: `sudo adduser --disabled-password --gecos "David Bowie" david-bowie`

## Logging


journalctl -u ssh.service


With `LogLevel VERBOSE` auth logs go to _/var/log/auth.log_ including a fingerprint of any key that was used.

Logins:

```
grep -Ei 'sshd.*(password|key)' /var/log/auth.log && zgrep -Ei 'sshd.*(password|key)' /var/log/auth*.gz
```

Failed logins:

```
grep -Ei 'invalid|failed' /var/log/auth.log && zgrep -Ei 'invalid|failed' /var/log/auth*.gz
```

See example and more details [here](https://serverfault.com/a/291768/126276).

## Reference

[Ubuntu - OpenSSH Server](https://ubuntu.com/server/docs/service-openssh)
[OpenSSH/Logging and Troubleshooting](https://en.wikibooks.org/wiki/OpenSSH/Logging_and_Troubleshooting)