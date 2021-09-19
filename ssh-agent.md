# ssh-agent

ssh-agent can load private keys and then provide them to clients like SSH. This is useful because for pass-phrase protected private keys you will only need to provide the password once when the key is loaded, and not every time it is used. The agent itself can be locked and unlocked with a password.

`ssh-keygen -lf ~/.ssh/id_rsa` shows you the fingerprint of the key in the file `~/.ssh/id_rsa`
`ssh-keygen -c -f ~/.ssh/id_rsa` update the comment on the key. The comment appears in `ssh-add -l`.

`ssh-add -l` list fingerprints of all loaded keys/identities.  
`ssh-add -L` list public keys loaded
`ssh-add -L | ssh-keygen -E md5 -lf /dev/stdin` list MD5 hash of all public keys loaded (useful to compare with Github Enterprise fingerprints)
`ssh-add -D` remove all loaded keys
`SSH_AGENT_PID=$(pgrep ssh-agent) ssh-agent -k` kill the ssh-agent

## Mac OS X

launchd starts the sshagent on login (see `launchctl list com.openssh.ssh-agent`) which loads keys it knows about.

`ssh-add -A` add all known keys to ssh-agent. If any have a passpharse stored in the keychain, that will be used.  
`ssh-add -K` add the _~/.ssh/id_rsa_ key to ssh-agent, using the passphrase in the keychain, or storing the passphrase in the keychain on first use.  
`ssh-add -K ~/.ssh/my_special_key` add _~/.ssh/my_special_key_ key to ssh-agent, using the passphrase in the keychain

### Config

```
# add any key loaded by ssh to ssh-agent
AddKeysToAgent yes

# use the keychain for storing/retrieving passphrases
UseKeychain yes
```

For more details see [OpenSSH updates in macOS 10.12.2](https://developer.apple.com/library/archive/technotes/tn2449/_index.html)

## Forwarding

`ssh -A` forwards your ssh-agent to the remote host so you the remote hose can use the keys you have in ssh-agent. Alternatively use `ForwardAgent yes` in your ssh config.

See man page for security implications.

When forwarding is enabled `ssh-add -l` will show the same set of keys locally as it will in the ssh session on the remote host.

## Troubleshooting

### Too many authentication failures

If ssh produces this error then it may be because ssh-agent has provided > 5 identities before the correct one and ssh gives up.

Add the following to your `.ssh/config` so that ssh only uses the authentication identity files configured in the ssh config file, even if ssh-agent offers more identities.

```
Host *
   IdentitiesOnly yes
```

### Could not open a connection to your authentication agent

If `ssh-add -l` on the remote host produces this error, check if the `SSH_AUTH_SOCK` env var has been set. If it hasn't been set:

1. Locally make sure `ForwardAgent yes` has been specified or `ssh -A` is used when connecting.
1. Make sure the remote host [allows SSH agent forwarding](https://developer.github.com/v3/guides/using-ssh-agent-forwarding/#your-system-must-allow-ssh-agent-forwarding)
   ie: add `AllowAgentForwarding yes` to `/etc/ssh/sshd_config` and then restart with `sudo systemctl restart sshd.service`

### Keys automatically being added to agent

Some fancy zsh prompts when in a git repo directory will do a [git fetch](https://github.com/sindresorhus/pure/blob/3b696be1c19187b903ca4afde411fb9295169ae8/pure.zsh#L307) which activates ssh.

## References

- [GitHub - Using SSH agent forwarding](https://docs.github.com/en/developers/overview/using-ssh-agent-forwarding)
- [SSH and ssh-agent](https://www.symantec.com/connect/articles/ssh-and-ssh-agent)
- [Saving SSH keys in macOS Sierra keychain](https://github.com/jirsbek/SSH-keys-in-macOS-Sierra-keychain)
