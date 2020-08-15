# git merge

To merge the hotfix branch into master:

```
git checkout master
git merge hotfix
```

## Fast-forward merge

A 'fast-forward merge' is simply moving the branch pointer to a future commit. There are no actual changes to merge.

A non fast-forward merge, eg: `git merge --no-ff work` will create a new merge commit (with no changes) with two parents - the current branch and work.

## Resolving conflicts during merge

Conflicts appear as unmerged files in `git status`.

`ours` - Current change, eg: HEAD. The currently checked out branch if merging, or the new HEAD being rebased on to.
`theirs` - Incoming change, eg: stash. The branch being merged in, or the branch being rebased.

You will need to resolve the conflicts, eg:
`git checkout --theirs .` to keep all their changes
`git mergetool unmerged_file_name` to run your merge conflict resolution tool on unmerged_file_name. See [man git-mergetool](http://schacon.github.com/git/git-mergetool.html) for more.

After changes are resolved you will need to add and commit to complete the merge:

```
git add .
git commit
```

`git merge --abort` to abort a merge. Reset your working copy to whatever state it was in before the merge, and remove the MERGE_HEAD branch.
