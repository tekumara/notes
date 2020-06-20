# bash variables

## export

Makes the variable available to child processes via the environment.

If you export a variable from .bashrc then you will see it in env.

If you don't it will still take effect for bash, but not child processes, won't be seen in env, but can be displayed via echo, eg: `echo $HISTSIZE`

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
