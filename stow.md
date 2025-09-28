# stow

Link everything in /mnt/fsx/user to ~

```
stow -vv . -t "$HOME" -d /mnt/fsx/user
# equivalent to
# cd /mnt/fsx/user && stow -vv . -t "$HOME"
```

Stow will link at the highest level that doesn't already exist.

eg:

given

- dotfiles/.config/jj/config.tml
- no ~/.config/jj

when

```
stow -vv dotfiles -t ~
```

Then ~/.config will contain a **directory symlink**, ie: `jj -> ../code/setup/dotfiles/.config/jj`.

But if ~/.config/jj exists, then ~/.config/jj will contain an **individual file** symlink, ie: `config.toml -> ../../code/setup/dotfiles/.config/jj/config.toml`. 

