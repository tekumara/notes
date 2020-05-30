# prezto

Needs the following changes to the out-of-the-box configuration to match oh-my-zsh:
* Set a theme otherwise [grep doesn't highlight words it finds](https://github.com/sorin-ionescu/prezto/issues/1764)
* Enable colours otherwise [directory listings aren't coloured](https://github.com/sorin-ionescu/prezto/issues/1765)
* [HISTFILE defaults to .zhistory rather than .zsh_history](https://github.com/sorin-ionescu/prezto/issues/1766)
* [File exists error when redirecting to an existing file](https://github.com/sorin-ionescu/prezto/issues/1767)
* [Delete word behaviour differs from oh-my-zsh](https://github.com/sorin-ionescu/prezto/issues/1774)

Things prezto has out of the box that oh-my-zsh doesn't:
* [cp prompts when overwriting an existing file](https://github.com/sorin-ionescu/prezto/issues/1845)
* auto-correction is enabled (pretty useful) + aliases for commands where it shouldn't be applied. (See [here](https://github.com/sorin-ionescu/prezto/blob/f4ca9ebfc913453f98ba6912a8c42684fd742cc1/modules/utility/init.zsh#L13))

Issues:
* I sometimes lose the git branch & working directory status in my prompt, or it becomes stale. I'm using the pure theme.

## editor

Defaults to emacs keybindings. If switched to vi, then [ALT + right arrow doesn't work](https://github.com/sorin-ionescu/prezto/issues/1763)