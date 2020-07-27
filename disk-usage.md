# Disk usage / file size

## Linux/BSD

Show top level folders only

`du -ksh *`

Show top 10 folders by size, recursing into subfolders

`du -a . | sort -n -r | head -n 10`

Show total for current dir

`du -shc`

Show number of files in current dir

`find . -type f | wc -l`

Show top 10 files by size

`find . -type f -exec du -Sh {} + | sort -rh | head -n 10`

Files, ordered by file name, but with file size: `find . -type f -printf "%p %s\n" | sort`

Get top 10 largest files `find . -printf '%s %p\n'| sort -nr | head -10`

Get file size total from ls
```
ls -alR  | grep -v '^d' | awk '{total += $5} END {print "Total:", total}'
```
same thing with find
```
find . -type f -printf "%s\n" | awk '{s+=$1} END {print s}'
```


