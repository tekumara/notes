# Find

Find any file in this dir or its subdirs that matches 'kdeb\*'. NB: wildcard is required and quotes should be used to prevent shell from expanding them.

```
find . -iname 'kdeb*'
```

To discard all errors:

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

Find all python files exclude those in _.venv/_:

```
find * -path ./.venv -prune -o -iname '*.py'
```

Update symlinks pointing at _/usr/local/bin/python3_:

```
find -L . -maxdepth 6 -samefile /usr/local/bin/python3 -iname python3 -exec ln -sf /usr/bin/python3.9 {} \;
```

Recursively delete all directories named .terraform:

```
find . -type d -name .terraform -prune -exec rm -rf {} \;
```
