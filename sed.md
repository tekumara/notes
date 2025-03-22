# Sed

Insert line before line with "config.vm.provider". Do inplace (ie: overwriting Vagrantfile)

```
sed -i "" -e '/config.vm.provider/ i\'$'\n''  config.vm.network :forwarded_port, guest: 8983, host: 8983' Vagrantfile
```

Replace the value of the variable ~SOLR_LOG with /solr/solr/logs

```
sed -i 's/SOLR_LOG=.*/SOLR_LOG=\/solr\/solr\/logs' solr.sh
```

Replace BASE= using a variable substitution ($~MONGO_HOME), note the following:

- use of double quotes so that substitution is performed
- use of | as a delimiter instead of slash, because $~MONGO_HOME contains slashes

```
sed -i "s|BASE=.*|BASE=$MONGO_HOME|" /etc/init.d/mongodb
```

Delete everything between `begin` and `end` (including `begin` and `end`):

```
sed -i '' "/begin/,/end/d" "$file"
```

Extract portion of path, eg:

```
echo work/tekumara/setup/pyproject.toml | sed 's#work/\(.*\)/pyproject.toml#\1#'
# tekumara/setup
```

Left trim whitespace

```
sed -e 's/^[[:space:]]*//g'
```

## Special characters

eg: given the line:

`if [[ $* =~ "newrelic" ]] && [[ -f "${NAGIOS_HOME}/.newrelic_enable" ]]`

and you want to remove `[[ $* =~ "newrelic" ]] &&`:

`sed -i 's|\[\[ \$\* =~ "newrelic" \]\] \&\& ||' ./bin/tomcat_ctl.sh`

see [What characters do I need to escape when using sed in a sh script?](http://unix.stackexchange.com/questions/32907/what-characters-do-i-need-to-escape-when-using-sed-in-a-sh-script)

## Delete line

To delete the whole line that contains the phrase 'newrelic is optional':

```
sed -i '/newrelic is optional/d' ./bin/tomcat_ctl.sh
```

## Sed on macOS

[sed on macOS doesn't support enhanced patterns](https://stackoverflow.com/a/23146221/149412) such as `\s`, `\b`, `\d` (unlike grep on macOS).

See `man re_format` for a list of enhanced patterns, which are not supported. Instead use the equivalent bracket expression, eg:

- `\s` = `[[:space:]]`
- `\S` = `[^[:space:]]`
- `\d` = `[[:digit:]]`
- `\b` has no equivalent.

Alternatively use perl instead.

## Multiple replacements

Multiple replacements can be strung together with a semicolon, eg:

```
sed 's/^/"/;s/,text/",text/'
```

or `-e`, eg:

```
sed -e 's/^/"/' -e 's/,text/",text/'
```

### Troubleshooting

`invalid command code`: use `-e` with `-i` otherwise macos sed will inteprete the next command as the backup suffix, eg: `sed -i -e 's/before/after/g' file.txt`

`in-place editing only works for regular files`: sed doesn't like symlinks

## Pattern is being partially replaced

Make sure your pattern is valid on macOS, eg: use `[[:digit:]]` instead of `\d`

## Prefix with newline

`echo hello | sed -e 's/^/\\n/'` produces `\nhello`
`echo hello | sed -e 's/^/\n/'` works
`echo hello | sed -e $'s/^/\\\n/'` also works. The `$'....'` contains a string literal in which bash performs C-style backslash substitution, e.g. `$'\n'` is translated to an actual newline. The `\\` is needed to produce a `\` which is required by sed in front of an actual newline. [ref](https://stackoverflow.com/a/11163357/149412)

## + not matching

Use `-E` to use extended regular expressions, eg: to reduce to a single whitespace:

```
echo "  foo        bar" | sed -E 's/[[:space:]]+/ /g'
```
