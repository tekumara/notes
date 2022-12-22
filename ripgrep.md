# ripgrep (rg)

## Usage

`--files` prints the names of any files that would be searched, without actually performing the search. This is useful to determine whether a particular file is being searched or not.

`--no-heading` output filename per match, rather than heading. Good from navigation from the terminal to a vscode tab.

`-l` to only show the filename, not the matched line

`-F` Treat the pattern as a literal string instead of a regular expression

`--hidden` search hidden files

`-tpy` search python file types (see [Manual filtering: file types](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#manual-filtering-file-types))

`-Tpy` exclude python file types.

Show js file types

`rg --type-list | rg '^js:'`

## Search and replace

```shell
rg -g '{setup.py,pyproject.toml,reqiurements.*}' -l "$search" "$dir" | xargs sed "s/$search/$replace/"
```

### Ripgrep appears to ignore top-level folder

If ripgrep isn't searching files it's probably because its obeying a `.gitignore` directive.

Try disabling the `.gitignore` logic: `rg --no-ignore ..`

Or use `-u` to disable smart search, eg: `rg -uuu` which is roughly equivalent to `grep -r`

### Globs

[Globs](https://github.com/BurntSushi/ripgrep/tree/master/globset) determine which files to include or exclude in the search. Globs are separated by comma and **no space**.

eg:

```shell
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
rg -Tjs # ignores *.js, *.jsx, *.vue

# search python files but not files named conftest.py
# NB: order of the globs is important. Later globs are applied on top of previous globs.
# So if the order is reversed, conftest.py will be included.
rg --glob '*.py' --glob '!conftest.py' --no-heading "import AppSettings"

```

In above examples the implicit path to search is `.` (the current directory).
If you supply files or directory as a path (explicitly or expanded) eg: `rg -g 'ansible/*' --files *` they will take precedence over the glob ([issue #725](https://github.com/BurntSushi/ripgrep/issues/725))
