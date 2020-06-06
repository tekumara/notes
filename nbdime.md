# nbdime

## To use with git

`nbdiff "HEAD^" HEAD` will show a nice diff of changes in the latest commit

To get this same result from `git diff` as `nbdiff` update your git config:
```
nbdime config-git --enable --global
```
This will update `$HOME/.config/git/attributes` and your global git config to use nbdime on `*.ipynb` files.