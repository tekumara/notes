# Git Notes - merge/rebase

A 'fast-forward merge' is simply moving the branch pointer to a future commit. There are no actual changes to merge. 

A non fast-forward merge, eg: `git merge --no-ff work` will create a new merge commit (with no changes) with two parents - thethe current branch and work.

eg: To merge the hotfix branch into master:

```
git checkout master
git merge hotfix
```

## Using egit for rebase

egit can be used for rebase although it may not rebase as well as using git from the command line. For example, it couldn't rebase changes in a file that had been renamed whereas git could. This may have been because of an older version of egit vs my git command line, or it may have been a configuration setting.

## Resolving conflicts during merge

Conflicts appear as unmerged files in `git status`. 
LOCAL (ours) will refer to the currently checked out branch, and REMOTE (theirs) will refer to the merged in branch.

You will need to resolve the conflicts, eg:
`git checkout --theirs .` to keep all their changes
`git mergetool unmerged_file_name` to run your merge conflict resolution tool on unmerged_file_name (eg: Beyond Compare - see [setup](http://www.scootersoftware.com/support.php?zz=kb_vcs#gitwindows)). See [git mergetool](http://schacon.github.com/git/git-mergetool.html) for more.

After changes are resolved you will need to add and commit to complete the merge:
```
git add .
git commit
```

`git merge --abort` to abort a merge. Resets your working copy to whatever state it was in before the merge, and remove the MERGE_HEAD branch.

## Rebase

[git rebase man page](http://linux.die.net/man/1/git-rebase)

A ''rebase'' is exactly the same as a merge and produces the same commit as a merge but it does not retain the branched history. If you examine the history of a rebase it will appear as a linear commit in the same branch, even if the changes actually occurred in a parallel branch. This makes for a cleaner history.

eg: To rebase wip on top of master
```
git checkout wip
git rebase master # place whatever is checked out (ie: wip) on top of master
```
Alternatively, you can do
`git rebase master wip #will checkout wip first, then rebase wip on top of master`

After wip is rebased on top of master you can fast-forward merge master so it points to the new head:
```
git checkout master
git merge 4e4573b
```

If you need to resolve a conflict, then the definitions of LOCAL and REMOTE are reversed compared to a merge, so in this example:
* LOCAL (ours) will refer to the rebase branch, ie: master
* REMOTE (theirs) will refer to the checked out branch, ie: wip
After resolving the conflict, commit with `git rebase --continue`

To perform an interactive rebase involving the last 3 commits on branch master:

```
git checkout master
git rebase HEAD~3
```

To amend a previous commit under master:
* checkout that commit
* create a new branch (eg: mod)
* make changes
* commit with amend
* rebase master on top of mod:
  * `git checkout master`
  * `git rebase mod`
* remove mod: `git branch -d mod`

NB: if you need to resolve a conflict: 
* LOCAL (ours) will refer to the rebase branch, ie: mod
* REMOTE (theirs) will refer to the checked out branch, ie:master
After resolving the conflict, commit with `git rebase --continue`

## To change the commit message on an old commit

Do an interactive rebase, eg: `git rebase -i HEAD~3`, then use the 'reword' command on the commit who's message you want to change. During the rebase the editor will appear for that commit and you can modify just the message.

