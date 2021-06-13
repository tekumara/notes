# tmux

- Start new session: tmux
- End session: Ctrl D
- Detach from session: Ctrl B D
- Attach to last session: tmux a
- Enter scroll mode: Ctrl B [
- Exit scroll mode: Ctrl C or Esc
- Help: Ctrl B ?
- Split window horizontally: Ctrl B "
- Switch to other pane: Ctrl B o
- List sessions: Ctrl b s

Move pane from another session to the current session:

- list current sessions and windows: ctrl-b
- to move identified session into the current window in a new split pane: ctrl-b :movep -s 0:0 (-s = source pane, here session 0, window 0)

## Config

Use https://github.com/gpakosz/.tmux
Modify ~/.tmux.conf.local and uncomment the line `#set -g history-limit 10000`
In order to use VI key bindings (eg: `/` for search) make sure the `EDITOR` environment variable is exported in your shell

This will give you:

Toggle mouse mode: `Ctrl b m`

- this is equivalent to `set -g mouse on` or `set -g mouse off`
- when mouse mode is off (default):
  - mouse selection will copy
  - on the command line the scroll wheel will scroll the shell history, or in vim, the vim window
- when mouse mode is on, the scroll wheel will scroll the terminal history, and mouse selection won't work

## Latest version

You need at least tmux 2.4 for `send-keys -X` to work.

Building from source ([ref](https://github.com/tmux/tmux)):

```
sudo apt-get install libevent-dev
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
```
