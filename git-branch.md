# git branch

## About branches

From the [Git User's Manual](http://rmaicle.github.io/doc/git-2.13.0/user_manual/chapter_1):

> When we need to be precise, we will use the word "branch" to mean a line of development, and "branch head" (or just "head") to mean a reference to the most recent commit on a branch. However, when no confusion will result, we often just use the term "branch" both for branches and for branch heads.
>
> Branches (and tags) are pointers (ie: references) to commits. Because a branch in Git is simply a lightweight movable pointer to a commit it is very cheap. Whatever is the current branch pointer will be automatically advanced to point to future commits.
>
> The branch/commit you are currently on is the special pointer called HEAD.
>
> All references are named with a slash-separated path name starting with "refs"; the names we’ve been using so far are actually shorthand:
>
> - The branch "test" is short for "refs/heads/test".
> - The tag "v2.6.18" is short for "refs/tags/v2.6.18".
> - "origin/master" is short for "refs/remotes/origin/master".
>
> The full name is occasionally useful if, for example, there ever exists a tag and a branch with the same name.

## Basic Usage

`git branch -a` to display all branches, including remote branches (tracked locally or not)

`git branch -r` show remote branches (tracked locally or not)

`git show-ref` shows all references, ie: all branches and tags with their SHA1

`git branch BRANCHNAME` creates a new branch reference pointing to the current HEAD.

`git push origin --delete featureY` delete the origin remote branch _featureX_

## Managing branches

Rollback the master branch so it now points to the previous commit

```
git branch -f master master~1
```

Branches merged into master

```
git branch --merged master | grep -v master
```

Branches not merged into master

```
git branch  --no-merged master
```

Delete branches merged into master

```
git branch --merged master | grep -v master | xargs git branch -d
```

Show any remote-tracking references (ie: origin/\*) that no longer exist on the remote.

```
git remote prune origin --dry-run
```

Delete remote-tracking references (ie: origin/\*). Local branches will remain

```
git remote prune origin
```

List branches on the remote origin

```
git ls-remote -h origin
```

List all references (tags, heads/branches, pull requests) on the remote origin

```
git ls-remote -h origin
```

List all remote branches in your local repo

```
git branch -r
```

Show which branches are tracking which remote branches:

```
git branch -vv
```

or

```
git remote show origin
```
