# git prune

See stale tracking branches (ie: `origin/*`) that no longer exist on origin

```
git remote prune origin --dry-run
```

Remove stale tracking branches (keeps the local branch itself):

```
git remote prune origin
```

Fetch new heads and remove stale local tracking branches:

```
git fetch -p
```

To manually remove a tracking branch

```
git branch -d -r origin/<name>
```

List branches including `gone` branches:

```
git branch -vv
```

Why are not all the pruned branches appearing as gone??? TODO: take output of `git remote prune origin` and pipe to `git branch -d` 

Identity local branches with a pruned (ie: gone) tracking branch:

```
git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'
```

Delete local branches with a pruned (ie: gone) tracking branch, if they have been merged:

```
git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}' | xargs git branch -d
```

Delete local branches with a pruned (ie: gone) tracking branch, regardless of merge status (use this for squash merged branches):

```
git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}' | xargs git branch -D
```

List local branches without a remote tracking branch:

```
git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv) | awk '{print $1}'
```

[Source](https://stackoverflow.com/a/33548037/149412)
