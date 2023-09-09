# Grep

Show more context, ie: 5 lines before and 5 lines after the match

```
grep -5 foo /tmp/bar.txt
```

Multiple patterns means OR, eg: to search for foo or bar in a line:

```
grep -e foo -e bar /tmp/my.log
```

Not matching text:

```
grep -v ERROR
```

Multiple negative matches, ie: lines without ERROR or WARN

```
grep -v -e ERROR -e WARN
```

Search all files and subdirectories (-r) of current directory for case insensitive (-i) pattern `boo`.

```
grep -ir boo .
```

Search all files and subdirectories (-r) of current directory that have the filename pattern `*.tsv` for case insensitive (-i) pattern `boo`.

```
grep -ir --include "*.tsv" boo .
```

## Basic vs extended vs perl regular expressions

> In basic regular expressions the meta-characters `?`, `+`, `{`, `|`, `(`, and `)` lose their special meaning; instead use the backslashed versions `\?`, `\+`, `\{`, `\|`, `\(`, and `\)`.

In extended and perl regular expressions they retain their special meaning.

`grep -E` enables ERE, ie: extended regular expressions. See [man re_format](https://www.unix.com/man-page/osx/7/re_format/). This includes [enhanced](https://stackoverflow.com/a/23146221/149412) extended REs, ie: `\s`, `\S` etc.

`grep -P` enables PCRE ie: perl-compatible regular expressions. Needed to support things like the non-greedy operator `?` or [look arounds](#look-arounds-pcre). Not available on BSD grep, see [PCRE on macOS](#pcre-on-macos).

### PCRE on macOS

To enable PCRE use the GNU version of grep from Homebrew's dupes library:

```
brew tap homebrew/dupes
brew install grep
```

Or install `pcregrep`:

```
brew install pcre
```

## Print match only

`grep -o` only prints the match, each match per line. If you only want the capture group, use PCRE or perl or ripgrep.

Split on `-`:

```
echo "abc-def-ghi" | grep -oE '[^-]+'
abc
def
ghi
```

Just the digits in a string:

```
grep -o '[0-9]\+' <<< "E: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 132492 (apt-get)"
132492
```

Count number of occurrences of the tag ToiletDetails (including multiple occurrences per line)

```
grep -o \<ToiletDetails ./src/main/resources/toilets.xml | wc -l
```

## Look arounds (PCRE)

Look arounds match a pattern only if it's followed or preceded by an assertion. The match doesn't include the assertion, eg: the look behind `(?<=ab)c` and will match `c` in the string `abc`. Look arounds pair well with `-o` to output just the match.

PCRE look arounds are fixed-with, but `\K` simulates a variable-length look behind assertion preceding a pattern to match, eg: `ab+\Kc` is approx. equivalent to `(?<=ab+)c` and will match `c` in the string `abbc`. It's not a true look behind because it consumes the text, see [Simulating variable-length lookbehind with \K](https://riptutorial.com/regex/example/2462/simulating-variable-length-lookbehind-with--k). Because of this `\K` is more efficient than a true look behind. It's also used as a more convenient short-form of `(?=pattern)`.

Return value of a key/value pair:

```
grep -oP 'key=\K(.*)' config.properties
```

Capture text in a tag using both a look behind and look ahead:

```
echo "<value>foo</value>" | grep -oP "<value>\K.*?(?=</value>)"
```

## Troubleshooting

### Searching on macOS file return all lines

The can happen if the file has old Mac style line breaks (CR only), as opposed to unix line breaks (LF only). See [linebreaks.md](linebreaks.md).
