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

Return just the digits in a string:

```
grep -o '[0-9]\+' <<< "E: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 132492 (apt-get)"
132492
```

Return value of a key/value pair:

```
grep -oP 'key=\K(.*)' config.properties
```

`\K` is the short-form (and more efficient form) of `(?<=pattern)` for a zero-width look-behind assertion before the text you want to output. The look-behind part (ie: key=) won't be output, but anything after it will be, even if outside the capture group.

`grep -P` enables PCRE ie: perl-compatible regular expressions. Needed to support things like the non-greedy operator `?` or `\K`. Not available on BSD grep, see [PCRE on macOS below](#pcre-on-macos)).
`grep -E` enables ERE, ie: extended regular expressions. See [man re_format](https://man.netbsd.org/re_format.7). This includes [enhanced](https://stackoverflow.com/a/23146221/149412) extended REs, ie: `\s`, `\S` etc.
`grep -o` only prints the match (not just capture group, for that use PCRE or perl), each match per line.

Capture text in a tag:

```
echo "<value>foo</value>" | grep -oP "<value>\K.*?(?=</value>)"
```

Not matching text:

```
grep -v ERROR
```

Multiple negative matches, ie: lines without ERROR or WARN

```
grep -v -e ERROR -e WARN
```

## Searching on macOS file return all lines

The can happen if the file has old Mac style line breaks (CR only), as opposed to unix line breaks (LF only). See [linebreaks.md](linebreaks.md).

## PCRE on macOS

To enable PCRE use the GNU version of grep from Homebrew's dupes library:

```
brew tap homebrew/dupes
brew install grep
```

Or install `pcregrep`:

```
brew install pcre
```
