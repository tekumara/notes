# Find

Find any file in this dir or its subdirs that matches 'kdeb\*'. NB: wildcard is required and quotes should be used to prevent shell from expanding them.

```
find . -iname 'kdeb*'
```

To discard all erorrs:

```
find . -iname 'kdeb*' 2>/dev/null
```

Execute command on all files in a directory

```
find . -type f -exec python ~/hackday/scripts/soup.py {} \;
```

Find a directories at the top level:

```
find * -type d -maxdepth 0
```
