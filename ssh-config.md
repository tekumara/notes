# ssh config

Remove old host and port when getting WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!

eg: localhost 2222

```
ssh-keygen -R \[localhost\]:2222
```

To avoid getting disconnected (ie: packet_write_wait / Write failed: Broken pipe):

```
Host *
 ServerAliveInterval 120
```

To specify an alternative username for all hosts, eg: to always connect as "someone", modify `~/.ssh/config` with:

```
Host *
 User someone
```

With a specific key:

```
Host *.mydomain
  User someone
  IdentityFile ~/.ssh/mydomain.key
```

Transparent jump box / bastion:

```
Host jump
  HostName 1.2.3.4
  IdentityFile ~/.ssh/ops
  User ubuntu

Host node05-icing-aws-syd
  HostName 172.1.1.93
  IdentityFile ~/.ssh/ops
  User ubuntu
  ProxyJump jump
```

## Querying

Determine identify file that will be used for github.com:

```
ssh -G github.com | grep identityfile
```

## Invalid format

Make sure your key file ends with an empty line.

## Shared persistent connections

Setup `~/.ssh/config/` with the following:

```
ControlMaster auto
ControlPath /tmp/ssh_mux_%h_%p_%r
ControlPersist 4h

Host xbmc
  HostName xbmclive.local
  User xbmc
```

ControlMaster / ControlPath - shared connections.

Creates a master connection the first time you connect. Subsequent connections can reuse the existing master connection.
To check if you have a master connection: `ssh -O exit xbmc`
To close a master connection: `ssh -O check xbmc`

ControlPersist - persistent connections. That will cause connections to hang around for 4 hours (or whatever time you specify) after you log out, ready to spring back into life if you request another connection to the same server during that time.

Host is an alias. `ssh xbmc` is the equivalent of `ssh xbmclive.local -l xbmc`

NB: tried `GSSAPIAuthentication no` but didn't have an effect.

## References

[SSH Can Do That? Productivity Tips for Working with Remote Servers](http://blogs.perl.org/users/smylers/2011/08/ssh-productivity-tips.html)
