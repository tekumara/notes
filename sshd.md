# sshd

## Install

Install (ubuntu):

```
sudo apt install openssh-server
```

Config in _/etc/ssh/sshd_config_. The commented out lines indicate what the default is, eg: `#PubkeyAuthentication yes` means PubkeyAuthentication is on.

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

To see logs:

```
journalctl -u ssh.service
```

Logins:

```
journalctl -u ssh.service | grep -Ei 'password|key'
```

Failed logins:

```
journalctl -u ssh.service | grep -Ei 'invalid|failed'
```

## Troubleshooting

```
Aug 28 12:39:20 ip-10-97-37-75 sshd[3383]: AuthorizedKeysCommand /usr/share/ec2-instance-connect/eic_run_authorized_keys ubuntu SHA256:LabnPmEHz5pmTRahIBzti3fdfFlnlj23i/ifc56hsEI failed, status 22
Aug 28 12:39:20 ip-10-97-37-75 sshd[3383]: Failed publickey for ubuntu from 10.97.34.166 port 41798 ssh2: RSA SHA256:LabnPmEHz5pmTRahIBzti3fdfFlnlj23i/ifc56hsEI
```




## Reference

[Ubuntu - OpenSSH Server](https://ubuntu.com/server/docs/service-openssh)
[OpenSSH/Logging and Troubleshooting](https://en.wikibooks.org/wiki/OpenSSH/Logging_and_Troubleshooting)
