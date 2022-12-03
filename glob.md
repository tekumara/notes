# glob options

## nullglob

nullglob expands non-matching globs to zero arguments, rather than to themselves in bash or the `no matches found` error in zsh.

## bash

[nullglob example](https://mywiki.wooledge.org/glob#nullglob):

```bash
$ ls *.c
ls: cannot access *.c: No such file or directory

# with nullglob set
shopt -s nullglob
ls *.c
# Runs "ls" with no arguments, and lists EVERYTHING
```

## zsh

`(N)` is a [glob qualifier](https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers) that enables `nullglob` on the glob and prevents the `no matches found` error if the glob doesn't match any files.

example:

```
ls $HOME/.kube/*.yaml(N)
```

is equivalent to `ls` if `$HOME/.kube/*.yaml` expands to nothing.
