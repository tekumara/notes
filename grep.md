# Grep

Show more context, ie: 5 lines before and 5 lines after the match

```
grep -5 foo /tmp/bar.txt
```

Count number of occurrences of the tag ToiletDetails (including multiple occurrences per line)

```
grep -o \<ToiletDetails ./src/main/resources/toilets.xml | wc -l
```

Search all files and subdirectories (-r) of current directory for case insensitive (-i) pattern `boo`.

```
grep -ir boo .
```

Multiple patterns means OR, eg: to search for foo or bar in a line:

```
grep -e foo -e bar /tmp/my.log
```

Search all files and subdirectories (-r) of current directory that have the filename pattern `*.tsv` for case insensitive (-i) pattern `boo`.

```
grep -r --include "*.tsv" bar .
```

Return value of a key/value pair:

```
grep -oP 'key=\K(.*)' config.properties
```

`\K` is the short-form (and more efficient form) of `(?<=pattern)` which you use as a zero-width look-behind assertion before the text you want to output. The look-behind part (ie: key=) won't be output, but anything after it will be, even if outside the capture group.

Capture text in a tag:

```
echo "<value>foo</value>" | grep -oP "<value>\K.*?(?=</value>)"
```

grep -P is perl syntax and is needed to support things like the non-greedy operator `?` or `\K`.
grep -o only prints the match (not just capture group, for that use perl), each match per line.

Not matching text:

```
grep -v ERROR
```

Multiple negative matches, ie: lines without ERROR or WARN

```
grep -v -e ERROR -e WARN
```

## Searching on Mac OS file return all lines

The can happen if the file has old Mac style line breaks (CR only), as opposed to unix line breaks (LF only). See [linebreaks.md](linebreaks.md).
