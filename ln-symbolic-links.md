# Symbolic links

## Linux

Create `link_name -> destination` in the current directory

```
ln -s destination link_name
```

Create the link `destination -> destination` inside _directory/_

```
ln -s destination directory/
```

## Replacing a symbolic link that points to a directory

This is rather unintuitive on Mac OS X.

Given a symbolic link _directory_, eg:

```
$ ls -al /usr/local/opt/gcc*
lrwxr-xr-x  1 tekumara  admin  21 27 Sep 12:31 /usr/local/opt/gcc -> ../Cellar/gcc@8/8.3.0
```

Then `ln -sf ../Cellar/gcc/8.3.0 gcc` will actually create a symlink _inside_ gcc, with the link name being the last component of the path, eg:

```
$ ls -al /usr/local/opt/gcc/8.3.0
lrwxr-xr-x  1 tekumara  admin  21 27 Sep 12:54 /usr/local/opt/gcc/8.3.0 -> ../Cellar/gcc@8/8.3.0
```

To avoid following the symlink directory, and replace a symlink that is a directory, use the `-h` (macOS) or `-n` (linux) option, eg:

```
$ ln -sfh ../Cellar/gcc/9.2.0 gcc
$ ls -al /usr/local/opt/gcc*
lrwxr-xr-x  1 tekumara  admin  21 27 Sep 12:31 /usr/local/opt/gcc -> ../Cellar/gcc/9.2.0

```
