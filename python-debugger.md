# python debugger

Install [pdb++](https://github.com/pdbpp/pdbpp):

```
pip install pdbpp
```

pdb++ is a drop-in replacement and has nice features like:

- [smart-command-parsing](https://github.com/pdbpp/pdbpp#smart-command-parsing), ie: defaulting to showing variables when their name is the same as a pdb command
- a sticky mode for showing the current line in context.
- tab auto-completion of variable names
- display expression that are printed at every breakpoint

To set a breakpoint:

```
import pdb; pdb.set_trace()
```

Commands:

- `s` step into
- `n` step over
- `r` step out
- `c` continue until breakpoint
- `?` help
- `l .` list lines around current line
- `ll` list source for current function
- `sticky` after execution print the source for the current function
- `wa` print stack trace
- `a` print args for current function

Set a breakpoint at in pandas.io.common at line 334:

```
b /Users/tekumara/.virtualenvs/s3fs052/lib/python3.7/site-packages/pandas/io/common.py:334
```

## Troubleshooting

### Debugging stdin

pdb takes over stdin, so if you pipe stdin to run you program pdb will error, eg:

```
echo foobar | python myapp
...
*** NameError: name 'foobar' is not defined
```

Alternatively you may see:

```
(Pdb) *** SyntaxError: invalid syntax
```

Direct pdb to use a fifo instead:

```
import pdb
mypdb=pdb.Pdb(stdin=open('fifo_stdin','r'), stdout=open('fifo_stdout','w'))
...
mypdb.set_trace()
...
```

See [How to debug python CLI that takes stdin?](https://stackoverflow.com/a/26975795/149412)
