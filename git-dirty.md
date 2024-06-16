# git dirty

Success if no changes to working directory:

```
test -z "$(git status --porcelain)"
```

List status in all sub dirs:

```
find . -name .git -type d -execdir sh -c 'pwd ;git status --porcelain' \;
```
