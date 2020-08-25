# ls

List contents of the `data` directory in the current directory, with the full absolute path:
```
ls $PWD/data/*
```
List contents of home directory, listing directory names rather than content, with the full absolute path:
```
ls -d ~/*
```
List contents of home directory, with full listing newest last:
```
ls -ltr ~
```
Get the newest file/dir in the home directory:
```
ls -t ~ | head -1
```
Get the newest file/dir in the home directory with absolute full path:
```
ls -td ~/* | head -1
```
Count number of files in a directory:
```
ls good-food/eat-out/review/restaurant | wc -l
```
List file names recursively, with a directory header for each group of files in the same directory
```
ls -R .
```
List file names recursively, each line prefixed by directory
```
find .
```
List files with human readable sizes (including total)
```
ls -lh
```
Log format, follow symlinks ([ref](https://unix.stackexchange.com/a/89319/2680))
```
ls -lL
```

It's not possible to list the full absolute path of a file AND recurse into every subdirectory. Use find instead:
```
find /usr/local/hadoop-3.2.0
```