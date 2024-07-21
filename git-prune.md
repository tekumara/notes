# git prune

## Stale tracking branches

See stale tracking branches (ie: `origin/*`) that no longer exist on origin

```
git remote prune origin --dry-run
# or using https://github.com/seachicken/gh-poi
gh poi --dry-run
```

Remove stale origin branches, and keeps the local branch:

```
git remote prune origin
```

Fetch new heads and remove stale local tracking branches:

```
git fetch -p
```

Remove stale origin branches and the same named local branch regardless of merge status (use this for squash merged branches):

```
git remote prune origin | awk '$2 == "[pruned]" {sub("origin/", "", $3); print $3}' | xargs git branch -D
```

Remove stale origin branches and the same named local branch if the local branch is merged:

```
git remote prune origin | awk '$2 == "[pruned]" {sub("origin/", "", $3); print $3}' | xargs git branch -d
```

To manually remove a tracking branch

```
git branch -d -r origin/<name>
```

### Gone branches

List branches including `gone` branches:

```
git branch -vv
```

Identify local branches with a pruned (ie: gone) tracking branch:

```
git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'
```

NB: Not all previously pruned branches will appear as gone. If the local branches had no tracking relationship there is no link and a `gone` state cannot be determined.

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

Delete branches merged into master

```
git branch --merged master | grep -v master | xargs git branch -d
```

[Source](https://stackoverflow.com/a/33548037/149412)

## git sync

[git-sync](https://github.com/jacobwgillespie/git-sync) will:

- If the local branch is outdated, fast-forward it;
- If the local branch contains unpushed work, warn about it;
- If the branch seems merged and its upstream branch was deleted, delete it.

See [hub-sync](https://hub.github.com/hub-sync.1.html).

Doesn't fetch branches on the remote that you don't have locally.
