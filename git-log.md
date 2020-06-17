# git log

Show full diffs of files
```
git log -p
```

Show file names and status (ie: modified, deleted etc.) with oneline for the commit
```
git log --name-status --oneline
```

Show list of files in a commit
```
git show --name-only 637a6264a4dc75658435fd41b8fe271b2c4c32c3
```

Show contents of file README.md in head:
```
git show HEAD:README.md
```

Show history for a file, continuing past renames:
```
git log --follow SAPI-Perf.jmx
```

Show history for a file, continuing past renames, with patches (ie: diffs) showing content changes
```
git log --follow -p -- file
```

Show history for files in current directory only:
```
git log .
```

Show hash and commit message for HEAD
```
git --no-pager show --summary
```

Show lists of commits (abbreviated SHA1 and title line) between tag rc-5017 and HEAD 
```
git log --pretty=oneline --abbrev-commit rc-5017..HEAD
```

For a given path only
```
git log --pretty=oneline --abbrev-commit rc-5017..HEAD module1/
```

Show lists of commits (date and title line) between tag rc-5017 and HEAD 
```
git log --pretty='%ad %s' --date=short rc-5017..HEAD
```

Show lists of commits (data, author, title line) between tag rc-5017 and HEAD 
```
git log --pretty='%ad %an %s' --date=short rc-5017..HEAD
```

Search for a file in the logs (across all branches)
```
git log --name-status --oneline --all | grep -B 50 -i queries.sql
```

Show list of file changes between two commits
```
git diff --name-only build-1159 build-1248
```

Show all branches that contain a commit
```
git branch -a --contains <SHA1sum-of-commit>
```

Show the last 3 commits for the current branch
```
git log -3
```

NB:
`rc-5017..HEAD` shows all commits on both branches from the common ancestor that differ, same as `rc-5017 master`
`rc-5017...HEAD` shows all commits on HEAD from the common ancestor with rc-5017
See [here](http://stackoverflow.com/questions/7251477/what-are-the-differences-between-double-dot-and-triple-dot-in-git-dif/7256391#7256391)

