# Git diff

`git diff main` compare working dir to main NB: excludes untracked files, stage these first if you want them to be part of the diff.  
`git diff main r2` compares tips of main and r2, ie: changes need to go from main -> r2. `r2 main` will show the same set of changes, but left and right side are swapped, ie: as a patch to go from r2 -> main.  
`git diff main r2 [<path>...]` for specific files  

## Ranges

Git diff compares endpoints and does not use the normal [dotted range notation](https://git-scm.com/docs/gitrevisions#_dotted_range_notations) (ie: `..` and `...`) used by [`git log`](git-log.md) and others. It's notation works as follows.

`git diff main..r2` is equivalent to `git diff main r2` (see above).

`git diff main...r2` determines the merge base of main and r2, ie: their common ancestor, and then shows the diff between r2 and the merge base. Equivalent to `git diff $(git merge-base main r2)..r2`. `r2...main` will show a different set of changes, ie: the diff between main and the merge base.

If there are multiple possible merge bases, it'll pick the most recent one. `git merge-base main r2` shows the merge base (use `--all` to see all).

If either commit is omitted, the HEAD is used its place, eg: `main

## Stats

`git diff --stat [<path>...]` Show number of lines changed per file and in total

## Show differences in a specific commit

`git diff 'r2^!'` (or `git diff "r2^" r2`) r2 with its ancestor

[git-diff man page](https://www.kernel.org/pub/software/scm/git/docs/git-diff.html)

## Diff showing name only

`git diff --name-only`
`git diff origin/rc8feb origin/rc1 --name-only` between the two commits

## Diff with a renamed/moved file

`git diff -C10% r2 r2^` or `git difftool -C10% r2 r2^`

This will compare the r2 to its parent and will show differences. Files that may have moved or been renamed will be identified as the same file if they have 10% similarity. The 10% similarity figure is a good benchmark when there may be other changes in the file.

Note that if you restrict your diff to just one path (eg: `git diff -C10% r2 r2^ a.txt`) you aren't going to be able to identify the renames or copies because you've excluded everything expect the single path and renames or copies - by definition - involve two paths.

## git status and changes in the working tree vs index

working tree = current state on disk
index = staging area

`git status` shows

- Changes to be committed = staged changes
- Changes not staged for commit = unstaged changes, but not yet added
- Untracked files

`git diff <filename>` shows only unstaged changes (aka changes not staged for commit), ie: changes made to the working tree vs the index.

`git diff --cached <filename>` shows only staged changes (aka changes to be committed), ie: changes made to the index vs r2

`git diff r2 filename` shows difference between r2 and working directory (includes both staged and unstaged changes), ie: changes made to the working tree vs r2.

## Troubleshooting

### unknown revision or path not in the working tree

eg:

```sh
git diff commitA..commitB
fatal: ambiguous argument 'commitA..commitB': unknown revision or path not in the working tree.
Use '--' to separate paths from revisions, like this:
'git <command> [<revision>...] -- [<file>...]'
```

Make sure commitA and commitB exist as local branches. If they have are remote branches, use `origin/commitA` or `origin/commitB`
