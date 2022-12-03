# Git diff

`git diff main` compare working dir to main
`git diff main HEAD` same as `git diff main..HEAD`
`git diff main..HEAD` shows the difference between the tips of main and HEAD ie: changes need to go from main -> HEAD. Same as `main HEAD`. `HEAD..main` will show the same set of changes, but with left and right side are swapped, ie: as a patch to go from HEAD -> main.
`git diff main...HEAD` changes on HEAD since the merge base (ie: common ancestor). Order sensitive. `HEAD...main` will show a different set of changes.
`git diff main HEAD [<path>...]` for specific files

## Stats

`git diff --stat [<path>...]` Show number of lines changed per file and in total

## Show differences in a specific commit

`git diff 'HEAD^!'` (or `git diff "HEAD^" HEAD`) HEAD with its ancestor

[git-diff man page](https://www.kernel.org/pub/software/scm/git/docs/git-diff.html)

## Diff showing name only

`git diff --name-only`
`git diff origin/rc8feb origin/rc1 --name-only` between the two commits

## Diff with a renamed/moved file

`git diff -C10% HEAD HEAD^` or `git difftool -C10% HEAD HEAD^`

This will compare the HEAD to its parent and will show differences. Files that may have moved or been renamed will be identified as the same file if they have 10% similarity. The 10% similarity figure is a good benchmark when there may be other changes in the file.

Note that if you restrict your diff to just one path (eg: `git diff -C10% HEAD HEAD^ a.txt`) you aren't going to be able to identify the renames or copies because you've excluded everything expect the single path and renames or copies - by definition - involve two paths.

## git status and changes in the working tree vs index

working tree = current state on disk
index = staging area

`git status` shows

- Changes to be committed = staged changes
- Changes not staged for commit = unstaged changes, but not yet added
- Untracked files

`git diff <filename>` shows only unstaged changes (aka changes not staged for commit), ie: changes made to the working tree vs the index.

`git diff --cached <filename>` shows only staged changes (aka changes to be commmitted), ie: changes made to the index vs HEAD

`git diff HEAD filename` shows difference between HEAD and working directory (includes both staged and unstaged changes), ie: changes made to the working tree vs HEAD.
