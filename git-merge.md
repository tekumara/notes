# git merge

To merge the hotfix branch into master:

```
git checkout master
git merge hotfix
```

## Fast-forward merge

A fast-forward merge moves the branch pointer to a future commit. No new merge commit is created.

A non fast-forward merge, eg: `git merge --no-ff work` will create a new merge commit contains changes and two parents - the current branch and work.

## Resolving conflicts during merge

Conflicts appear as unmerged files in `git status`.

- _ours_ = current change, updated upstream eg: HEAD. The currently checked out branch if merging, or the new HEAD being rebased on to.
- _theirs_ = incoming change, stashed changes. The branch being merged in (eg: stashed changes), or the branch being rebased.

ie:

- when merging my_branch into main, main is --ours
- when rebasing my_branch onto main, main is still --ours

You will need to resolve the conflicts, eg:

- `git checkout --ours .` to keep all our changes
- `git checkout --theirs .` to keep all their changes, followed by git add .
- `git mergetool unmerged_file_name` to run your merge conflict resolution tool on unmerged_file_name. See [man git-mergetool](http://schacon.github.com/git/git-mergetool.html) for more.
- `git rm file_name` to delete a file that has changes but was deleted by them or deleted by us.

After changes are resolved but they will still show as unmerged, including added/deleted files.

You will need to add and commit to complete the merge:

```
git add .
git commit
```

If you get a `does not have their version` error during checkout, nothing will have been updated, so you need to surgically checkout only those updated in both versions:

To use theirs:

```
# First, handle only the files that CAN be checked out to theirs (UU conflicts)
git status --porcelain | grep "^UU" | cut -c4- | xargs -r git checkout --theirs --

# Then handle deletions - remove files that were deleted by them (UD status)
git status --porcelain | grep "^UD" | cut -c4- | xargs -r git rm

# add any changes
git add -u
``

`git merge --abort` to abort a merge, ie: reset your working copy to whatever state it was in before the merge, and remove the MERGE_HEAD branch.
```
