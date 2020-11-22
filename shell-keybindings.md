# Key bindings

## Diag

To view keys being sent

```
$ sed -n l
^[f

$ cat -v
^[f
```

Alternatively press `<CTRL-v>key` at the prompt to see key codes for `key`.

To view key bindings in the shell

```
bindkey
```

Keys are often bound to widgets. The standard widgets are described in `man zshzle /STANDARD`

To see the definition of a command

```
zle -l | grep backward-kill-word
```
