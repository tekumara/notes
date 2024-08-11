# zsh functions

## Functions

A function runs inside the current shell process, whereas a script is started and run in a sub-shell.

Functions are useful for modifying the current shell environment.

## Loading functions

`autoload` or `function -u` is used to load functions `$fpath`. On execution it creates an undefined function that is lazy-loaded when first used.

An undefined function does not have a body, eg:

```zsh
❯ autoload -Uz foobar
❯ which foobar
foobar () {
    # undefined
    builtin autoload -XUz
}
```

When `foobar` is first called, zsh will search `$fpath` to load the function definition from a file named `foobar` or `foobar.zwc`.

autoload flags include:

- `-U` suppress alias expansion when the function is loaded
- `-z` mark the function to be autoloaded as native zsh

## fpath

`$fpath` is the search path for function definitions. Its similar to `$path` which is the search path for an executable script or binary, except unlike `$path` function definition in `$fpath` must be explicitly autoloaded before its used.

`$fpath` contains `/usr/local/share/zsh/site-functions` by [default](https://unix.stackexchange.com/a/607827/2680).

`$FPATH` and `$fpath` are tied parameters, containing the same value in different formats (see [typeset -T](https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html)). The uppercase param is a string separated by colons. The lowercase param is an array. Its normally easier to work with the array.

## References

- [man zshbuiltins](https://linux.die.net/man/1/zshbuiltins) - see autoload
- [The Z Shell Manual - Functions](https://zsh.sourceforge.io/Doc/Release/Functions.html)
- [Stack Overflow - What does autoload do in zsh?](https://stackoverflow.com/a/63661686/149412)
- [Stack Overflow - How to define and load your own shell function in zsh](https://unix.stackexchange.com/a/33898/2680)
- [Stack Overflow - autoload -Uz flags](https://stackoverflow.com/a/12575883/149412)
