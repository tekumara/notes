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

Show contents of file README.md in r2:

```
git show r2:README.md
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

Show hash and commit message for r2

```
git --no-pager show --summary
```

Show lists of commits (abbreviated SHA1 and title line) between tag main and r2

```
git log --pretty=oneline --abbrev-commit main..r2
```

For a given path only

```
git log --pretty=oneline --abbrev-commit main..r2 module1/
```

Show lists of commits (date and title line) between tag main and r2

```
git log --pretty='%ad %s' --date=short main..r2
```

Show lists of commits (data, author, title line) between tag main and r2

```
git log --pretty='%ad %an %s' --date=short main..r2
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

Show every commit that touched a specific line or lines:

```
git log -L110,112:/lib/client.js
```

NB: Use [git blame](git-blame.md) if you want to follow the lines over file copies/renames.

## Search

Search for commit messages that match pattern

```
git log --grep=<pattern>
```

Search for commits with patch text that contains added/removed lines that match pattern, `-p` shows the patch:

```
git log -G<regex> -p
```

Search for commits that change the number of occurrences of the string, ie: adds or deletes it (aka pickaxe). A patch that updates it isn't included. `-p` shows the patch.

```
git log -S<string> -p
```

See these additional [pickaxe examples](https://tekin.co.uk/2020/11/patterns-for-searching-git-revision-histories).

## Ranges

git log accepts [range revisions](https://git-scm.com/docs/gitrevisions#_specifying_ranges) to specify a set of commits. The dotted range notation, ie: `..` and `...`, works as follows.

`git log main r2` shows all commits on main and r2

`git log main..r2` shows unique commits on r2 that aren't on main. `r2..main` will show all commits on main that aren't on r2 (ie: order sensitive). Defined as `git log "^main" r2`.

`git log main...r2` shows unique commits on either branch but not both ie: removes common ancestors. Same as `git log r2...main` (ie: order insensitive). Defined as `git long r1 r2 --not $(git merge-base --all r1 r2)`)

### vs git diff

[git diff](git-diff.md#ranges) and git log use similar notation (`..` and `...`) but work differently. "git diff" compares the file tree at two specific commits. "git log" identifies a set of commits by walking the commit graph. git diff uses `...` to pick the _most recent_ merge base as the comparison commit. Whereas git log uses `...` to show unique commits by removing commits common to both branches (ie: removing commits reachable from _all_ merge bases).

### References

- [Stack overflow - What are the differences between double-dot ".." and triple-dot "..." in Git diff commit ranges?](http://stackoverflow.com/questions/7251477/what-are-the-differences-between-double-dot-and-triple-dot-in-git-dif/7256391#7256391)
