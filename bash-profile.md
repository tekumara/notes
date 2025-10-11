# bash profile

profile files are _/etc/profile_, _~/.bash_profile_, _~/.bash_login_, _~/.profile_.

They are only executed at login time, eg: when sshing in, or using `bash -l`

They are not executed when running `bash` in an existing shell, or starting a bash terminal in Xbuntu.

## bash login shell

`bash -l` will start a login shell.

For both a login and non-login shell, env vars from the parent will be inherited.

However because a login shell executes /etc/profile, on Mac OS this calls [path_helper](https://github.com/yb66/path_helper?tab=readme-ov-file#why-replace-it) which moves the system paths (eg: `/usr/*`, `/System/*` etc) to the front of `PATH`. This will affect shims like pyenv, fnm etc. that override system paths.

## References

- [Configuring your login sessions with dot files](http://mywiki.wooledge.org/DotFiles)
- [.bash_profile vs .bashrc](https://joshstaiger.org/archives/2005/07/bash_profile_vs.html)
