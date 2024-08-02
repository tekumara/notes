# zsh functions

## Functions

A function runs inside the current shell process, whereas a script is started and run in a sub-shell.

Functions are useful for modifying the current shell environment.

## autoload

`autoload` or `function -u` creates an undefined function that is lazy-loaded from `$fpath`.

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

Autoload is not only useful for lazy loading. Its used even when you immediately call the function as a way to load the function from `$fpath`.

autoload flags include:

- `-U` suppress alias expansion when the function is loaded
- `-z` mark the function to be autoloaded as native zsh

## fpath

`$fpath` is the search path for function definitions. Its analog is `$path` which is the search path for an executable script or binary.

`$fpath` contains `/usr/local/share/zsh/site-functions` by [default](https://unix.stackexchange.com/a/607827/2680).

Zsh maintains `$FPATH` and `$fpath` as linked parameters. The uppercase version is a string separated by colons. The lowercase version is an array. Its normally easier to work with the array.

## References

- [man zshbuiltins](https://linux.die.net/man/1/zshbuiltins) - see autoload
- [The Z Shell Manual - Functions](https://zsh.sourceforge.io/Doc/Release/Functions.html)
- [Stack Overflow - What does autoload do in zsh?](https://stackoverflow.com/a/63661686/149412)
- [Stack Overflow - How to define and load your own shell function in zsh](https://unix.stackexchange.com/a/33898/2680)
- [Stack Overflow - autoload -Uz flags](https://stackoverflow.com/a/12575883/149412)
