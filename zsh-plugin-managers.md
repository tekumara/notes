# zsh plugin managers

## zplug

zplug has some confusing behaviour where plugins are specified in `.zshrc` but the master list (including those added for the command line) is in `$ZPLUG_HOME/packages.zsh`. Removing a plugin from `.zshrc` doesn't remove it. You have to modify `$ZPLUG_HOME/packages.zsh` as well. [ref](https://github.com/zplug/zplug/issues/108#issuecomment-636329109)

## zgen

It makes it easy to load plugins from frameworks (oh-my-zsh, presto) and github repos.
Also has functionality for auto-updating plugins.
It's fast because it uses a static init script.
But it requires regenerating the init script whenever .zshrc changes. Sometimes you need to restart the shell twice for changes to take effect.