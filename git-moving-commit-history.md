# Moving commit history from one repo to another

## 1. Split out a subset of commits that affect a directory

eg: to move all commits in an old repo affecting files in `scala/` to a new repo

In the old repo

```
# create a scala branch with full commit history, but containing only changes to files in the scala/ directory
git checkout master
# the files in the new subtree commits with be unprefixed, ie: in the root directory
git subtree split --prefix scala --branch scala
```

## 2. Import the commits into the new repo

In the new repo, to import the branch from the old repo

```
# fetch the scala branch from the old repo
git remote add oldrepo ~/projects/oldrepo
git fetch oldrepo scala
# switch to branch scala pointing a FETCH_HEAD
git checkout scala
```

The new repo will now have a scala branch containing all commits, but files will have the `scala/` prefix removed.

## 3. Merge into master with a directory prefix

To create a merge commit on master, merging the scala branch in and prefixing all files with scala211/:

```
git checkout master
git subtree add -P scala211 -m "merged scala branch under directory scala211/" scala
git remote remove oldrepo
```

## Troubleshooting

> fatal: refusing to merge unrelated histories

When merging, use --allow-unrelated-histories, eg:

```
git merge scala --allow-unrelated-histories
```

## References

[Splitting sub-folder(s) out into a new Git repository](https://making.close.com/posts/splitting-sub-folders-out-into-new-git-repository)
