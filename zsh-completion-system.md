# zsh completion system

The [zsh completion system](http://zsh.sourceforge.net/Doc/Release/Completion-System.html).

## compinit

To initialise, load from $fpath using [autoload](zsh-functions#autoload):

```
autoload -Uz compinit && compinit
```

[`compinit`](https://github.com/zsh-users/zsh/blob/master/Completion/compinit) initialises:

- completion system functions like `compdef` and [`compdump`](https://github.com/zsh-users/zsh/blob/master/Completion/compdump).

- completions for the current session

completions for the current session are initialised by loading the [completion arrays](https://github.com/zsh-users/zsh/blob/09c5b10dc2affbe4e46f69e64d573b197c14b988/Completion/compinit#L113) from the dump file if it exists (see [compdump](#compdump) below).

Otherwise `compinit` [iterates through `$fpath`](https://github.com/zsh-users/zsh/blob/09c5b10dc2affbe4e46f69e64d573b197c14b988/Completion/compinit#L523) to find completion functions that with an underscore; eg: `_docker` to complete `docker` commands.
`compinit` reads the first line looking for a `#compdef` or `#autoload` tag, and then executes `compdef` or `autoload` respectively. See [Autoloaded files](http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Autoloaded-files).

To search your completion functions, ie: file names in `$fpath` starting with `_`:

```
echo $fpath | xargs -J % find -E  % -name '_*' | fzf
```

## compdef

The [`compdef` command](https://github.com/zsh-users/zsh/blob/09c5b10dc2affbe4e46f69e64d573b197c14b988/Completion/compinit#L202) registers a completion, ie: it associates completion functions with specific commands or patterns. eg: `compdef _docker docker` enables completion for the name docker via the `_docker` function. See [Functions](http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Functions-3).

A completion is registered by adding the command and function to the [completion arrays](https://github.com/zsh-users/zsh/blob/09c5b10dc2affbe4e46f69e64d573b197c14b988/Completion/compinit#L381).

The `compdef` command requires `compinit` has been run, otherwise you'll see the error:

```
command not found: compdef
```

To be decoupled from initialisation use `#compdef` in files in `$fpath` instead (see above).

## compdump

`compdump` creates a dump file (`~/.zshcompdump`) containing all the completions registered by `compdef`, ie: the completion arrays (ie: [`_comps`, `_services` and `_patcomps`](https://github.com/zsh-users/zsh/blob/09c5b10dc2affbe4e46f69e64d573b197c14b988/Completion/compdump#L39C19-L39C25)).

`compinit` reads the dump file if it exists, rather than iterate through `$fpath`. If it doesn't exist it will walk `$fpath` and [run `compdump`](https://github.com/zsh-users/zsh/blob/09c5b10dc2affbe4e46f69e64d573b197c14b988/Completion/compinit#L549) to save the dump file unless the `-D` flag is used.

`compinit -C` will skip checks and load the dump file if it exists, ie: it skips

- the security check (compaudit)
- [counting](https://github.com/zsh-users/zsh/blob/09c5b10dc2affbe4e46f69e64d573b197c14b988/Completion/compinit#L472) the number of files in `$fpath` and comparing this [to the number of files in the dump](https://github.com/zsh-users/zsh/blob/09c5b10dc2affbe4e46f69e64d573b197c14b988/Completion/compinit#L489). By default compinit with regenerate the arrays (and save a new dump) if this is the case but `-C` ignores this altogether.

`compinit -w` explains why the dump file wasn't loaded (if it wasn't). NB: in the following explanation:

> Loading dump file skipped, regenerating because: -D flag given

"Regenerating" means regenerating the arrays by walking `$fpath` ie: its not referring to the dump file.

## services

Allows aliases to be established for a command. See the [zcompsys man page](https://linux.die.net/man/1/zshcompsys#:~:text=Each%20name%20may%20also%20be%20of%20the%20form%20%27cmd%3Dservice%27).

## Troubleshooting

If a completion doesn't load, then it may be missing from the dump file. Remove the dump file and re-init:

```
rm ~/.zcompdump
compinit
```

### command not found

```
code <TAB>(eval):1: command not found: _code
(eval):1: command not found: _code
(eval):1: command not found: _code
(eval):1: command not found: _code
```

A completion that used to exist has been removed.
Remove the association and re-init:

```
rm ~/.zcompdump
compinit
```
