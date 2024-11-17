# iterm2

## Preferences

## Page Up/Page Down

To use Page Up/Page Down for scrolling only when in non-interactive apps (eg: when at the command line, but not in TUI apps like k9s, dive etc.) then check "Preferences -> Profiles -> Choose profile -> Keys -> General -> Page up, page down, home and end scroll outside interactive apps". NB: This will be overridden by specific key bindings for Page Up/Page Down, so make sure you don't have any in Preferences -> Keys -> Key Bindings.

### Load prefs from customer folder

- Preferences -> General -> Preferences -> Load preferences from a custom folder or URL -> folder name
- Check "Save changes to folder when iTerm2 quits"

or do this via [defaults](https://github.com/tekumara/setup/blob/45096ccc8c90fb0aeb07df5658ae81df61a936e7/install/defaults.sh#L7).

### Natural editing

Natural editing includes these shortcuts (similar to Terminal.app):

- word backwards using Option ⌥ + ←
- word forwards using Option ⌥ + →.
- delete a word backwards using Option ⌥ + ⌫
- delete the whole line using Command ⌘ + ⌫

To enable:

- Go to Preferences... > Profiles > Keys
- Duplicate the current Profile
- Press Load Preset...
- Select Natural Text Editing
- Press Other Actions... Set as default

[ref](https://apple.stackexchange.com/questions/154292/iterm-going-one-word-backwards-and-forwards)

#### In .zshrc

Key bindings can also be configured in zsh, eg:

```
bindkey "\e[1;3D" backward-word     # ⌥←
bindkey "\e[1;3C" forward-word      # ⌥→
bindkey "^[[1;9D" beginning-of-line # cmd+←
bindkey "^[[1;9C" end-of-line       # cmd+→
```

However they won't work in remote or container terminals, so setting them in iterm is preferred.

[ref](https://stackoverflow.com/a/73241402/149412)
