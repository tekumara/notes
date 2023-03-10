# ssh-agent

ssh-agent can load private keys and then provide them to clients like SSH. This is useful because for pass-phrase protected private keys you will only need to provide the password once when the key is loaded, and not every time it is used. The agent itself can be locked and unlocked with a password.

`ssh-keygen -lf ~/.ssh/id_rsa` shows you the public sha256 fingerprint of the key in the file `~/.ssh/id_rsa`. If this is a RSA/DSA private key it will look for the .pub file.
`ssh-keygen -c -f ~/.ssh/id_rsa` update the comment on the key. The comment appears in `ssh-add -l`.
`ssh-keygen -y -f ~/.ssh/id_rsa` read private key, print public key. Will always prompt for a passphrase regardless of whether it has been loaded in ssh-agent (if the key has one).

`ssh-add -l` list public fingerprints of all loaded keys/identities. This is roughly a sha256 of the public key, specifically it is: `awk '{print $2}' ~/.ssh/id_ed25519.pub | base64 -d | shasum -a 256 | xxd -r -p | base64 | tr -d =`
`ssh-add -L` print public keys loaded.
`ssh-add -L | ssh-keygen -E md5 -lf /dev/stdin` list public MD5 hash of keys loaded (useful to compare with Github fingerprints)
`ssh-add -D` remove all loaded keys
`SSH_AGENT_PID=$(pgrep ssh-agent) ssh-agent -k` kill the ssh-agent

## Mac OS X

`ssh-add ~/.ssh/my_special_key` add key to ssh-agent.
`ssh-add --apple-use-keychain ~/.ssh/my_special_key` add key to ssh-agent and if the key has a passphrase add it to the keychain. If the key is already in the keychain, use it's stored passphrase (if any) when adding to ssh-agent.

`ssh-add -d ~/.ssh/my_special_key` remove key from ssh-agent.
`ssh-add --apple-use-keychain -d ~/.ssh/my_special_key` remove key from the ssh-agent and the keychain.

`ssh-add --apple-load-keychain` [load all ssh keys stored in the keychain](https://github.com/apple-oss-distributions/OpenSSH/blob/6bfdfb3/openssh/keychain.m#L197) into ssh-agent.

Keys are stored as a `SSH: <path>` item in the Login Items keychain. If the key has a passphrase this will be stored as the item's password and used to decrypt the key when loading into ssh-agent.

launchd starts ssh-agent on login (see `launchctl list com.openssh.ssh-agent`) without any keys loaded.

### SSH Config

SSH can be told to add keys to the agent and the keychain when they first successfully used to authenticate:

```
# add key used by ssh into ssh-agent
AddKeysToAgent yes

# store the key path in the keychain with passphrase (if any)
UseKeychain yes
```

Note that `ssh-add --apple-use-keychain` will not add a key without a passphrase to the keychain. But with `UseKeychain yes` ssh will! You may want to add a passphrase-less key into the keychain so that `ssh-add --apple-load-keychain` can be used to load it (eg: at startup) along with all other keys into the ssh-agent. To add a passphrase-less key:

1. enable `AddKeysToAgent yes` and `UseKeychain yes` via ssh config for the host that uses the key
1. make sure the key is not yet present in the agent
1. use ssh to sucessfully connect to the host which will add the key to the agent **and** the keychain.

For more details see [OpenSSH updates in macOS 10.12.2](https://developer.apple.com/library/archive/technotes/tn2449/_index.html)

## SSH keys

SSH will offer:

- keys explicitly provided via `-i` or the `IdentityFile` setting in _~/.ssh/config_
- all keys in the agent

## SSH forwarding

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

### Error connecting to agent: Permission denied

Check you have permissions to the socket specified by $SSH_AUTH_SOCK, or try with `sudo`.

### Could not open a connection to your authentication agent

If `ssh-add -l` on the remote host produces this error, check if the `SSH_AUTH_SOCK` env var has been set. If it hasn't been set:

1. Locally make sure `ForwardAgent yes` has been specified or `ssh -A` is used when connecting.
1. Make sure the remote host [allows SSH agent forwarding](https://developer.github.com/v3/guides/using-ssh-agent-forwarding/#your-system-must-allow-ssh-agent-forwarding)
   ie: add `AllowAgentForwarding yes` to `/etc/ssh/sshd_config` and then restart with `sudo systemctl restart sshd.service`

### Keys automatically being added to agent or cannot be deleted from the agent

Some fancy zsh prompts when in a git repo directory will do a [git fetch](https://github.com/sindresorhus/pure/blob/3b696be1c19187b903ca4afde411fb9295169ae8/pure.zsh#L307) which activates ssh, which may be configured to add keys to the agent

## References

- [GitHub - Using SSH agent forwarding](https://docs.github.com/en/developers/overview/using-ssh-agent-forwarding)
- [SSH and ssh-agent](https://www.symantec.com/connect/articles/ssh-and-ssh-agent)
- [Saving SSH keys in macOS Sierra keychain](https://github.com/jirsbek/SSH-keys-in-macOS-Sierra-keychain)
