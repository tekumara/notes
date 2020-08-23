# bash variables

## set vs export

`set` will show all variables, `env` will only show variables that are exported to subprocesses.

Variables assigned in _.bashrc_ will be only available to the current shell, and not exported to subprocesses, eg: `HISTSIZE`

Set a variable in the context of the current shell only:

```
# foo2 is not exported, so isn't in the environment of a subprocess
foo2=bar && python -c 'import os; print(os.environ["foo2"])'

KeyError: 'foo2'

echo $foo2
bar

# foo2 is not exported
env | grep -i foo2
```

Set a shell variable and make it available to child processes, eg:

```
export foo=bar && python -c 'import os; print(os.environ["foo"])'
bar
```

Modify the environment of a subprocess started from the shell:

```
foo=bar python -c 'import os; print(os.environ["foo"])'
bar

# NB: foo is not set in the shell
echo $foo

```

The above is equivalent to: `env foo=bar python -c 'import os; print(os.environ["foo"])'

Note that `echo` is a bash builtin so behaves differently:

```
# echo can see shell variables
foo=bar && echo $foo
bar

# but nothing echoed here because echo runs in the current process
foo2=bar echo $foo2
```

## References

[Difference between set, export and env in bash](https://hackjutsu.com/2016/08/04/Difference%20between%20set,%20export%20and%20env%20in%20bash/)

## exporting DYLD_LIBRARY_PATH weirdness

This is strange:

```
$ export DYLD_LIBRARY_PATH=/usr/local/Cellar/gcc@6/6.5.0_2/lib/gcc/6/
$ set | grep -i dyld
DYLD_LIBRARY_PATH=/usr/local/Cellar/gcc@6/6.5.0_2/lib/gcc/6/

# not exported, why?
$ env | grep -i dyld
```

If I remove the underscores, it exports, ie:DYLDLIBRARYPATH

https://stackoverflow.com/questions/58126808/how-can-i-export-dyld-library-path
