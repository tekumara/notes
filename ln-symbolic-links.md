# Symbolic links

## Linux

Create `target -> source` in the current directory

```
ln -s source target
```

target is the symbolic link's name.

## Replacing a symbolic link that points to a directory

This is rather unintuitive on Mac OS X.

If the target is an existing symlink pointing at a directory, eg:

```
$ ls -al python
lrwxr-xr-x  1 tekumara  admin    28B  2 Jan 16:09 python -> ../Cellar/python@3.10/3.10.9
```

Then `ln -sf ../Cellar/python@3.10/3.10.10 python` follows the symlink and creates a symlink **inside** _python/_. The link name is the last component of the path (ie: `3.10.10`), eg:

```
$ ls -al python/
lrwxr-xr-x   1 tekumara  admin    29B 15 Jan 08:11 3.10.10 -> ../Cellar/python@3.10/3.10.10
...
```

To avoid following the symlink, and replace an existing symlink, use the `-h` (macOS) or `-n` (linux) option, eg:

```
$ ln -sfh ../Cellar/python@3.10/3.10.10 python
$ ls -al python
lrwxr-xr-x  1 tekumara  admin    28B  2 Jan 16:09 python -> ../Cellar/python@3.10/3.10.10
```
