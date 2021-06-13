# ripgrep (rg)

## Usage

### Ripgrep appears to ignore top-level folder

If ripgrep isn't searching files it's probably because its obeying a `.gitignore` directive.

Try disabling the `.gitignore` logic: `rg --no-ignore ..`

### Globs

`--files` prints the names of any files that would be searched, without actually performing the search. This is useful to determine whether a particular file is being searched or not.

[Globs](https://github.com/BurntSushi/ripgrep/tree/master/globset) determine which files to include or exclude in the search.
eg:

```
# list names of all files in any `ansible/` subdirectory (ignoring files in .gitignore).
# NB the * is required.
$ rg -g 'ansible/*' --files
code/proj1/ansible/common.yml
code/proj1/ansible/run-playbook.sh
code/proj2/ansible/common.yml

# case insensitive, same as above
$ rg --iglob 'Ansible/*' --files
code/proj1/ansible/common.yml
code/proj1/ansible/run-playbook.sh
code/proj2/ansible/common.yml

# exclude paths too
$ rg -g 'ansible/*' -g '!proj1' --files
code/proj2/ansible/common.yml

# search hidden files and directories for the text `checktime`, excluding multiple paths
rg -g '!{.Trash,Library,.rustup}' --hidden checktime

# ignore javascript files
rg -g '!*.js'
```

In above examples the implicit path to search is `.` (the current directory).
If you supply files or directory as a path (explicitly or expanded) eg: `rg -g 'ansible/*' --files *` they will take precedence over the glob ([issue #725](https://github.com/BurntSushi/ripgrep/issues/725))

## Install Ubuntu

There's no Ubuntu package yet.

Install via cargo: `cargo install ripgrep`

To install the docs, find the latest version https://github.com/BurntSushi/ripgrep/releases and download, eg:

```
wget -O - https://github.com/BurntSushi/ripgrep/releases/download/0.7.1/ripgrep-0.7.1-x86_64-unknown-linux-musl.tar.gz | tar -zxvf - -C /tmp

#binary, if not installed via cargo
sudo cp /tmp/ripgrep*/rg /usr/local/bin/

#man pages
mkdir -p /usr/local/man/man1/
sudo cp /tmp/ripgrep*/rg.1 /usr/local/man/man1/
mandb

#bash completions
sudo cp /tmp/ripgrep*/complete/rg.bash-completion /usr/share/bash-completion/completions/rg

#zsh completions
sudo cp /tmp/ripgrep*/complete/_rg /usr/share/zsh/functions/Completion/Zsh/
```
