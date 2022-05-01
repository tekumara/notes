# tty

By default, Unix-style tty (i.e. console) drivers will take input in [cooked mode](https://en.wikipedia.org/wiki/Terminal_mode). Cooked mode provides command-line editing, before enter is hit and the input is sent to the program.

On MacOS the line input length in cooked mode is limited to ~1024 chars per line ([ref](https://superuser.com/a/265898/12874)).

When trying to paste more than 1024 chars, use `pbpaste | <cmd>` instead.

## Scrambled text on remote ssh

infocmp -a xterm-kitty | ssh myserver tic -x -o \~/.terminfo /dev/stdin
