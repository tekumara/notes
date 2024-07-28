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

User config files ([ref](https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout))

```
.zshenv → [.zprofile if login] → [.zshrc if interactive] → [.zlogin if login] → [.zlogout sometimes]
```

See

- [ArchLinux Zsh - Startup/Shutdown files](https://wiki.archlinux.org/index.php/Zsh#Startup/Shutdown_files)
- [An Introduction to the Z Shell - Startup Files](http://zsh.sourceforge.net/Intro/intro_3.html)

System config files on macOS:

_/etc/zprofile_  
_/etc/zshrc_ - sets a few things like the location of zsh_history

## plugins

- {name}.plugin.zsh (antigen style)
- {name}/init.zsh (prezto style)
- \*zsh (zsh style)
- \*sh (shell style)

[ref](https://github.com/jedahan/zr/pull/29/files)

## options

`setopt` lists options.

[Z Shell Manual - Options](http://zsh.sourceforge.net/Doc/Release/Options.html)

## path

The `PATH` variable and the `path` array are automatically synchronized ([ref](https://wiki.archlinux.org/index.php/Zsh#Configuring_$PATH)).

## profiling

Poorman's: `for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done`
rust's hyperfine: `hyperfine --warmup 3 'zsh -i -c exit;'`

## history

With fzf, when history sharing across shells is enabled (setopt SHARE_HISTORY), history written by shell A won't be available in shell B until re-rendering the prompt in B (e.g. by pressing Enter at the prompt). ([ref](https://github.com/junegunn/fzf/pull/2251))

## prompt

Minimal prompt:

```
PROMPT="$ "
```

Remove hostname from pure prompt:

```
prompt_pure_state[username]=
```

## null glob

To avoid a `no match` error when a glob doesn't expand to anything use the `(N)` qualifier, eg:

```
files=($HOME/.kube/*.yaml(N) $HOME/.k3d/kubeconfig*.yaml(N))
```

## start empty zsh

To start zsh without any env vars set and without loading config files:

```
env -i zsh -f
```
