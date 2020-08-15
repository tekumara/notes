# git rebase

[git rebase man page](http://linux.die.net/man/1/git-rebase)

A rebase is exactly the same as a merge and produces the same commit as a merge but it does not retain the branched history. If you examine the history of a rebase it will appear as a linear commit in the same branch, even if the changes actually occurred in a parallel branch. This makes for a cleaner history.

eg: To rebase wip on top of master

```
git checkout wip
git rebase master # place whatever is checked out (ie: wip) on top of master
```

Alternatively, you can do
`git rebase master wip`
This will checkout wip first, then rebase wip on top of master

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