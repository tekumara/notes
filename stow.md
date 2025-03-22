# stow

Link everything in /mnt/fsx/user to ~

```
stow -vv . -t "$HOME" -d /mnt/fsx/user
# equivalent to
# cd /mnt/fsx/user && stow -vv . -t "$HOME"
```
