# nbdime

## To use with git

`nbdiff "HEAD^" HEAD` will show a nice diff of changes in the latest commit

To modify git so `git diff` shows the same result as `nbdiff`:
```
nbdime config-git --enable --global
echo "*.ipynb diff=jupyternotebook" >> .gitattributes
```