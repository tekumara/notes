# bash testing

Prefer `[[` (extended test command) to `[` because `[[` supports regex and substring matching and has better error handling.

EG:

```
    if [ $(cmd that errors with no std out) != 200 ]; then
      ...
    fi
```

Will produce a message `[: !=: unary operator expected` but the script will still complete successfully.

```
    if [[ $(cmd that errors with no std out)  != 200 ]]; then
      ...
    fi
```

Will raise and error and stop.

`[[` is only available in bash and zsh.

## Examples

`[[ -z "$query_execution" ]]` True if the length of string is zero.
`[[ -n "$sql" ]]` True if the length of string is nonzero.

## References

[test manpage](http://linuxcommand.org/lc3_man_pages/testh.html)
