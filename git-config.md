# git config

Show user email and where it comes from:

```
git config --includes --show-origin --show-scope --get user.email
```

## Troubleshooting

Recursive include's don't work, eg:

_.gitconfig_:

```
[include]
    path = ~/.gitconfig_local
```

_.gitconfig_local_:

```
[includeIf "gitdir:~/code/ghec/"]
    [user]
        email = "work@email.com"
```

Results in `email = "work@email.com"` being set regardless of gitdir.
