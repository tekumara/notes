# Key bindings

## Terminal

The terminal (xterm, iTerm2, the cloud IDE etc.) will set the keybindings sent to the shell. These are interpreted by the shell's line editor.

[terminfo](https://pubs.opengroup.org/onlinepubs/7908799/xcurses/terminfo.html) is the terminal capability database. It describes a device's capabilities and character sequences that effect it.

## Diagnostics

To view keys being sent press `<CTRL-v>key` at the prompt to see key codes for `key`.

NB: `sed -n l`, `cat -v`, `od -c` are alternatives, but don't show everything.

## bash

bash uses a modified version of readline as its line editor.

To view key bindings in bash

```
bind -p
```

## zsh

zsh uses [zle](http://zsh.sourceforge.net/Guide/zshguide04.html) as its line editor. It has an emacs and vim mode. The emacs mode has less surprises.

To view key bindings

```
bindkey
```

Keys are often bound to widgets. The standard widgets are described in `man zshzle /STANDARD`

To see the definition of a command

```
zle -l | grep backward-kill-word
```

See also [18 Zsh Line Editor](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html)

### ;3D instead of backward word in zsh

Occurs when a terminal sends `^[[1;3D;3` rather than `^[b` for `⌥ + ←`.

In the case of cloud9/tmux this happens when the terminal is put into application keypad mode.

See:

- [3.8: Why do the cursor (arrow) keys not work? (And other terminal oddities.)](http://zsh.sourceforge.net/FAQ/zshfaq03.html)
- [Set key bindings alt + arrow keys to move between words](https://github.com/sorin-ionescu/prezto/pull/1688)
- [What are the characters printed when Alt+Arrow keys are pressed?](https://unix.stackexchange.com/questions/73669/what-are-the-characters-printed-when-altarrow-keys-are-pressed)
- [ZshWiki Keybindings](http://zshwiki.org/home/keybindings/)

### cloud9 scroll wheel doesn't work

In the case of cloud9 this happens when the terminal is in application keypad mode, see [#436](https://github.com/c9/core/issues/436)

## Application mode

Arrow keys

- in cursor mode, transmit `Esc [ <code>` ANSI sequences
- in application mode, transmit `Esc O <code>` sequences.

The numeric keypad:

- in numeric mode, transmits ASCII chars ie: numbers
- in application mode, transmits `Esc O <code>` sequences ie: arrow keys

`smkx` enables application mode.
`rmkx` disables application mode.

It is expected that applications which transmit the `smkx` string will always transmit the `rmkx` string to the terminal before they exit.

The [default _/etc/zsh/zshrc_ on Ubuntu puts the terminal into application mode](http://www.f30.me/2012/10/oh-my-zsh-key-bindings-on-ubuntu-12-10/). macOS does not do this. Ubuntu puts the terminal into application mode so the terminfo database can be used to specify bindkey sequences instead of hardcoded sequences. This relies on the terminfo being correct, which is not always the case! For this reason, omz is looking to move away from application mode and the terminfo database ([#5113](https://github.com/ohmyzsh/ohmyzsh/pull/5113)).

See:

- [terminfo, curses, application keypad ...](http://web.archive.org/web/20130113200931/http://homes.mpimf-heidelberg.mpg.de/~rohm/computing/mpimf/notes/terminal.html)
- [Help with application mode](https://github.com/ohmyzsh/ohmyzsh/issues/5228)
- [Ditch smkx in favor of custom bindkey extension](https://github.com/ohmyzsh/ohmyzsh/pull/5113)
