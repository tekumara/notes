# zplug

zplug has some confusing behaviour where plugins are specified in `.zshrc` but the master list (including those added for the command line) is in `$ZPLUG_HOME/packages.zsh`. Removing a plugin from `.zshrc` doesn't remove it. You have to modify `$ZPLUG_HOME/packages.zsh` as well. [ref](https://github.com/zplug/zplug/issues/108#issuecomment-636329109)