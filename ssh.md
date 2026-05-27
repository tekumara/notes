# ssh

## Passwordless login with SSH keys

Create a key on the client:

```
ssh-keygen -t ed25519 -C "you@example.com"
```

Copy the public key to the server:

```
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@server
```

If `ssh-copy-id` is unavailable:

```
cat ~/.ssh/id_ed25519.pub | ssh user@server 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
```

Test:

```
ssh user@server
```

## Troubleshooting

### Too many authentication failures

If ssh produces this error then it may be because the client has provided > 5 identities before the correct one, or asking for a password, and ssh gives up.
