# comby

## File filtering

Comby does a recursive search from the current directory (or the directory provided via `-d`).

eg:

```
comby 'foo' 'bar'            # recursive search all files
```

The search can be narrowed to only include specific patterns, eg:

```
comby 'foo' 'bar' config.env                    # recursive search for files named config.env
comby 'foo' 'bar' -f config.env                 # recursive search for files named config.env
comby 'foo' 'bar' requires.txt -f config.env    # recursive search for files named requires.txt or config.env
comby 'foo' 'bar' requires.txt -f .py           # recursive search for files named requires.txt or ending in .py
```

When using template via `-templates` (or its alias `-config`) the match and rewrite template positional arguments are omitted. To filter, use the `-f` flag because comby will interprets the first positional argument as the match template (see [these docs](https://comby.dev/docs/configuration#running)).

If `-f` is an extension that maps to a matcher, that matcher will be implicitly used, unless `-custom-matcher` or `-matcher` is specified

Comby will exclude hidden directories, ie: by default it runs with `-exclude-dir .` This can be overridden, eg:

```
comby -exclude-dir .,node_modules ...   # exclude hidden directories and node_modules
```

## Whitespace

[Whitespace](https://comby.dev/docs/basic-usage#about-whitespace) in the match template will match any combination and length of contiguous newlines and spaces.
Whitespace in the rewrite will appear as written.

## Match newline at top level

`-match-newline-at-toplevel` :[hole] at the top level (ie: not within a recognized block syntax) will match zero or more newlines too. Enabled on [comby.live](https://comby.live) by default.

eg: `:[hole]` here will match the newlines, and without `-match-newline-at-toplevel` there will be no match:

```
printf 'a = x()\n\nb = y()\n\nc = z()\n' | comby "a = x():[hole]c = z()" ":[hole]" .py -stdin -match-newline-at-toplevel
```

If the match template contains newlines, `-match-newline-at-toplevel` is not needed, eg:

```
printf 'a = x()\n\nb = y()\n\nc = z()\n' | comby $'a = x()\n:[hole]\nc = z()' ":[hole]" .py -stdin
```

Match newline at top level can introduce the `Timeout for input: A long string...!` warning when a match starts with a hole. See this warning:

> WARNING: The match template starts with a :[hole]. You almost never want to start a template with :[hole], since it matches everything including newlines up to the part that comes after it. This can make things slow. :[[hole]] might be what you're looking for instead, like when you want to match an assignment foo = bar(args) on a line, use :[[var]] = bar(args). :[hole] is typically useful inside balanced delimiters.

## Match inside strings

[Structural matching](https://comby.dev/docs/basic-usage#structural-matching) means Comby understands the interaction between delimiters, strings, and comments. The literals that constitute a delimeter, string or comment is defined by the matcher, which is inferred from a file's extension (or provided via `-matcher`).

Comby won't match within a string unless the template contains string quotes, eg:

```
'":[pre]matchme:[post]"'
```

Alternatively, use the text matcher which [ignores strings](https://github.com/comby-tools/comby/blob/a36c63fb1e686adaff3e90aed00e88404f8cda78/lib/kernel/matchers/languages.ml#L15) (`raw_string_literals` defines which literals Comby considers to be a string. For the text matcher there are none)
