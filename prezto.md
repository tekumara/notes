# prezto

## Features

[Base](https://github.com/sorin-ionescu/prezto/blob/a3a51bdf6c485ff60153e80b66915626fcbacd4f/runcoms/zpreztorc#L32):

- [environment](https://github.com/sorin-ionescu/prezto/tree/master/modules/environment) - general shell options, quote pasted urls, colorize man pages (termcap), unsetopt HUP
- [terminal](https://github.com/sorin-ionescu/prezto/tree/master/modules/terminal) - sets terminal window title to the current directory (the pure theme does this anyway)
- [editor](https://github.com/sorin-ionescu/prezto/tree/master/modules/editor) - sets editor specific key bindings options and variables.
- [history](https://github.com/sorin-ionescu/prezto/tree/master/modules/histhistory) - set share history across sessions and other options
- [directory](https://github.com/sorin-ionescu/prezto/tree/master/modules/directory) - sets directory options (eg: EXTENDED_GLOB)and prevents > from overwriting existing files.
- [utility](https://github.com/sorin-ionescu/prezto/tree/master/modules/utility) - coloured directory listings (ie: `ls -G`), `ll`, safe ops that ask the user for confirmation before performing a destructive operation, spell correction
- [completion](https://github.com/sorin-ionescu/prezto/tree/master/modules/completion) - [zsh-completions](https://github.com/zsh-users/zsh-completions) with customisation.
- [prompt](https://github.com/sorin-ionescu/prezto/tree/master/modules/prompt) - nice prompts, eg: [pure](https://github.com/sindresorhus/pure)

Others:

- [spectrum](https://github.com/sorin-ionescu/prezto/tree/master/modules/spectrum) - provides variables for 256 color escape codes. Loaded by utility.
- [helper](https://github.com/sorin-ionescu/prezto/tree/master/modules/helper) - helper functions for developing modules. Loaded by utility.
- [history-substring-search](https://github.com/sorin-ionescu/prezto/tree/master/modules/history-substring-search) - zsh-history-substring-search: when pressing up/down arrows, completes the end of a command from history

## vs oh-my-zsh

Needs the following changes to the out-of-the-box configuration to match oh-my-zsh:

- Set a theme otherwise [grep doesn't highlight words it finds](https://github.com/sorin-ionescu/prezto/issues/1764)
- Enable colours otherwise [directory listings aren't coloured](https://github.com/sorin-ionescu/prezto/issues/1765)
- [HISTFILE defaults to .zhistory rather than .zsh_history](https://github.com/sorin-ionescu/prezto/issues/1766)
- [File exists error when redirecting to an existing file](https://github.com/sorin-ionescu/prezto/issues/1767)
- [Delete word behaviour differs from oh-my-zsh](https://github.com/sorin-ionescu/prezto/issues/1774)

Things prezto has out of the box that oh-my-zsh doesn't:

- safe ops - [cp prompts when overwriting an existing file](https://github.com/sorin-ionescu/prezto/issues/1845)
- auto-correction is enabled (pretty useful) + aliases for commands where it shouldn't be applied. (See [here](https://github.com/sorin-ionescu/prezto/blob/f4ca9ebfc913453f98ba6912a8c42684fd742cc1/modules/utility/init.zsh#L13))

## Issues

1. I sometimes lose the git branch & working directory status in my prompt, or it becomes stale. I'm using the pure theme.
1. editor defaults to emacs keybindings. If switched to vi, then [ALT + right arrow doesn't work](https://github.com/sorin-ionescu/prezto/issues/1763)
1. the python plugin causes zsh to die on startup, see [#739](https://github.com/sorin-ionescu/prezto/issues/739)

## Options

prezto will set these options:

```
alwaystoend
autocd
autopushd
autoresume
nobgnice
nocaseglob
cdablevars
nocheckjobs
combiningchars
completeinword
correct
extendedglob
extendedhistory
noflowcontrol
histexpiredupsfirst
histfindnodups
histignorealldups
histignoredups
histignorespace
histsavenodups
histverify
nohup
interactive
interactivecomments
login
longlistjobs
monitor
pathdirs
nopromptcr
promptsubst
pushdignoredups
pushdsilent
pushdtohome
rcquotes
sharehistory
shinstdin
zle
```
