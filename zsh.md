# zsh

All man pages: `man zshall`

## versions

`echo $ZSH_VERSION` current shell's version  
`/bin/zsh --version` macOS version  
`/usr/local/bin/zsh --version` homebrew version  

## Use Homebrew zsh

To switch to Homebrew zsh, first check it's specified in /etc/shells, if /usr/local/bin/zsh is missing, add it:

```
sudo bash -c 'echo /usr/local/bin/zsh >> /etc/shells'
```

then

```
chsh -s /usr/local/bin/zsh
```

## zshrc

User config files
```
.zshenv → [.zprofile if login] → [.zshrc if interactive] → [.zlogin if login] → [.zlogout sometimes]
```

System config files on macOS:  

*/etc/zprofile*  
*/etc/zshrc* - sets a few things like the location of zsh_history

## completion

The [zsh completion system](http://zsh.sourceforge.net/Doc/Release/Completion-System.html)

`compinit` initialises completion for the current session, and installs utility functions like `compdef`. `autoload -U compinit` is recommended to autoload it.

`compinit` will create a dump file (`~/.zshcompdump`) that will be read on future invocations. `compinit -C` will only create the dump file if one doesn't already exist.

`$fpath` is the [function search path](http://zsh.sourceforge.net/Doc/Release/Functions.html) and contains `/usr/local/share/zsh/site-functions`. The convention for autoloaded functions used in completion is that they start with an underscore; eg: `_docker` to complete `docker` names. When `compinit` runs it reads all files in `$fpath` and reads the first line looking for a `#compdef` or `#autoload` tag, see [Autoloaded files](http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Autoloaded-files).

A `#compdef` tag or `compdef` command, defines a completion, eg: `compdef _docker docker` enables completion for the name docker via the `_docker` function. See [Functions](http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Functions-2)

## completion troubleshooting

If a completion doesn't load, then trying running `compdump` to recreate the dump file (you can also delete it)

```
code <TAB>(eval):1: command not found: _code
(eval):1: command not found: _code
(eval):1: command not found: _code
(eval):1: command not found: _code
```

A completion that used to exist has been removed.
To fix remove the completions:
```
rm ~/.zcompdump
```

## plugins

* {name}.plugin.zsh (antigen style)
* {name}/init.zsh (prezto style)
* *zsh (zsh style)
* *sh (shell style)  

[ref](https://github.com/jedahan/zr/pull/29/files)

## options

`setopt` lists options. 

[Z Shell Manual - Options](http://zsh.sourceforge.net/Doc/Release/Options.html)