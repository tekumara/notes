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
