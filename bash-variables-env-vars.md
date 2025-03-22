# bash variables and env vars

## set vs export

`set` will show all variables, `env` will only show variables that are exported to subprocesses.

Variables assigned in _.bashrc_ will be only available to the current shell, and not exported to subprocesses, eg: `HISTSIZE`

Set a variable in the context of the current shell only:

```bash
# foo1 is not exported, so isn't in the environment of a subprocess
foo1=bar && python -c 'import os; print(os.environ["foo1"])'

KeyError: 'foo1'

echo $foo1
bar

# foo1 is not exported
env | grep -i foo1

```

Export a shell variable and make it available to child processes:

```bash
export foo2=bar && python -c 'import os; print(os.environ["foo2"])'
bar

echo $foo2
bar
```

Modify the environment of a subprocess started from the shell:

```bash
foo3=bar python -c 'import os; print(os.environ["foo3"])'
bar

# equivalent
env foo3=bar python -c 'import os; print(os.environ["foo3"])'
bar

# NB: but foo3 is not set in the shell
echo $foo3
    
# Take the COLUMNS shell var and export it to a subprocess that is piped (defaults to 80 when stdout is piped)
COLUMNS=$COLUMNS python -c 'import shutil; print(shutil.get_terminal_size())' | head
os.terminal_size(columns=151, lines=24)
```

Note that `echo` is a bash builtin so behaves differently:

```bash
# echo can see shell variables
foo4=bar && echo $foo4
bar

# but not here because echo runs in the current process
foo4=bar echo $foo4
```

## References

[Difference between set, export and env in bash](https://hackjutsu.com/2016/08/04/Difference%20between%20set,%20export%20and%20env%20in%20bash/)

## DYLD_LIBRARY_PATH weirdness

This is [strange](https://stackoverflow.com/questions/58126808/how-can-i-export-dyld-library-path):

```
$ export DYLD_LIBRARY_PATH=/usr/local/Cellar/gcc@6/6.5.0_2/lib/gcc/6/
$ set | grep -i dyld
DYLD_LIBRARY_PATH=/usr/local/Cellar/gcc@6/6.5.0_2/lib/gcc/6/

# not exported, why?
$ env | grep -i dyld
```

If I remove the underscores, ie:`DYLDLIBRARYPATH`, it exports.
