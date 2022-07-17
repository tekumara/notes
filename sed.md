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

## Special characters

eg: given the line:

`if [[ $* =~ "newrelic" ]] && [[ -f "${NAGIOS_HOME}/.newrelic_enable" ]]`

and you want to remove `[[ $* =~ "newrelic" ]] && `

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

### Trouble shooting

`invalid command code o`: make sure you provide a file extension to -i, eg: `sed -i.bak ...` or `sed -i ''` to replace without backing up (note on GNU/linux this would be `sed -i''` ie: no space after the flag).

`in-place editing only works for regular files`: sed doesn't like symlinks

## Multiple replacements

Multiple replacements can be strung together with a semicolon, eg:

```
sed 's/^/"/;s/,text/",text/'
```

## Prefix with newline

`echo hello | sed -e 's/^/\\n/'` produces `\nhello`

`echo hello | sed -e $'s/^/\\\n/'` works correctly. The `$'....'` contains a string literal in which bash performs C-style backslash substitution, e.g. `$'\n'` is translated to an actual newline. The `\\` is needed to produce a `\` which is required by sed in front of an acutal newline. [ref](https://stackoverflow.com/a/11163357/149412)
