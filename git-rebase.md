# git rebase

[git rebase man page](http://linux.die.net/man/1/git-rebase)

A rebase is exactly the same as a merge and produces the same final file state as a merge but it does not retain the branched history. If you examine the history of a rebase it will appear as a linear commit in the same branch, even if the changes actually occurred in a parallel branch. This makes for a cleaner history.

To rebase wip on top of master

```
git checkout wip

# place whatever is checked out (ie: wip) on top of master
git rebase master
```

Alternatively, you can do `git rebase master wip`. This will checkout wip first, then rebase wip on top of master.

After wip is rebased on top of master you can fast-forward merge master so it points to the new head:

```
git checkout master
git merge wip
```

If you need to resolve a conflict, then the definitions of LOCAL and REMOTE are reversed compared to a merge, so in this example:
* *ours* will refer to the rebase target branch, ie: master
* *theirs* will refer to the checked out branch, ie: wip
After resolving the conflict, commit with `git rebase --continue`

## To change the commit message on a previous commit

Do an interactive rebase, eg: `git rebase -i HEAD~3`, then use the 'reword' command on the commit who's message you want to change. During the rebase the editor will appear for that commit and you can modify just the message.
