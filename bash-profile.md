# bash profile

Bash profiles are for login shells, ie: the first login via console or ssh.

Running `bash` in an existing shell, or starting a new bash terminal in Xbuntu, does not start a login shell.

Login shells might include additional things, like a message of the day or diagnostic info.

profile files are _/etc/profile_, _~/.bash_profile_, _~/.bash_login_, _~/.profile_. They are only executed by login shells

.bashrc is executed for interactive non-login shells. Its usually a subset of what you want to do at login, and is sourced from a bash_profile.

## bash login shell

`bash -l` will start a login shell.

For both a login and non-login shell, env vars from the parent will be inherited.

However because a login shell executes /etc/profile, on Mac OS this calls [path_helper](https://github.com/yb66/path_helper?tab=readme-ov-file#why-replace-it) which moves the system paths (eg: `/usr/*`, `/System/*` etc) to the front of `PATH`. This will affect shims like pyenv, fnm etc. that override system paths.

## References

- [Configuring your login sessions with dot files](http://mywiki.wooledge.org/DotFiles)
- [.bash_profile vs .bashrc](https://joshstaiger.org/archives/2005/07/bash_profile_vs.html)
