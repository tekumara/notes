# bash variables

A variable can be assigned and then used in subsequent commands:
```
foo=bar && echo $foo
bar
```

The shell will expand it, but it won't be in the environment of subprocesses.

To show variables: `set`

Variables assigned in .bashrc will be available to the current shell, but not exported to subprocesses, eg: `HISTSIZE`

## export

Makes the variable available to child processes as an environment variable.

To see what's in the environment variables: `env`

[Difference between set, export and env in bash](https://hackjutsu.com/2016/08/04/Difference%20between%20set,%20export%20and%20env%20in%20bash/)

## set vs env

`set` will show local + exported variables, `env` will only show exported variables.

This is strange:
```
$ export DYLD_LIBRARY_PATH=/usr/local/Cellar/gcc@6/6.5.0_2/lib/gcc/6/
$ env | grep -i dyld
$ set | grep -i dyld
DYLD_LIBRARY_PATH=/usr/local/Cellar/gcc@6/6.5.0_2/lib/gcc/6/
_=DYLD_LIBRARY_PATH
```
https://stackoverflow.com/questions/58126808/how-can-i-export-dyld-library-path
