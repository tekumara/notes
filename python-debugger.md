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
import pdb; pdb. set_trace()
```

Commands:

- `s` step into
- `n` step over
- `r` step out
