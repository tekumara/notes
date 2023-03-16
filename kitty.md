# kitty

kitty_mod = ctrl+shift

## Troubleshooting

### Scrambled text on remote ssh

infocmp -a xterm-kitty | ssh myserver tic -x -o \~/.terminfo /dev/stdin
