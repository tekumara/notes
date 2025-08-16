# jj

## vs git

In general jj has fewer concepts than git. The core ones are:

- [commits](https://jj-vcs.github.io/jj/latest/glossary/#commit) A snapshot of the files in the repository at a given point in time.
- [changes](https://jj-vcs.github.io/jj/latest/glossary/#change) Changes provide stable identifiers even as the change (the commit) is amended or modified over time.
- the [working copy](https://jj-vcs.github.io/jj/latest/working-copy/) contains the files you are currently working on and any file changes are automatically committed at the beginning of most `jj` commands.

jj doesn't have an explicit staging area or index. But they can be modelled using jj's concept by using the parent commit (`@-`) as your staging area. You can move changes from the workspace commit (`@`) to the staging area (`@-`) explicitly, like "git add". And you can "git commit" your staging area by creating a new commit above the staging area to create a new staging area.

[ref](https://news.ycombinator.com/item?id=44657764)

> jj commands will usually put the git repo in a "detached HEAD" state, since in jj there is not concept of a "currently tracked branch"

No concept of untracked changes see [#5225](https://github.com/jj-vcs/jj/issues/5225#issuecomment-2868938712)

see [Comparison with Git](https://jj-vcs.github.io/jj/latest/git-comparison/)

## snapshot.auto-track

By default all working copy files are auto snapshotted/committed. To disable this:

```
[snapshot]
auto-track = 'none()'
```

Or to avoid tracking claude:

```
jj config set --repo snapshot.auto-track "~(.claude/ | CLAUDE.md)"
```

## bookmarks

In Jujutsu (jj), “bookmarks” are like Git branches: named pointers to commits.
Running `jj bookmark track ...` sets a local bookmark to follow its remote counterpart (upstream), so future `jj git fetch` updates will automatically fast‑forward your local bookmark when the remote moves.

Track a specific bookmark: `jj bookmark track main@origin`

## push

To create a name implicitly on push

```
jj git push -c @
```

## conflicts

[conflicts](https://jj-vcs.github.io/jj/latest/conflicts/) are stored logically inside commits. They can be postponed until you need to resolve, you aren't forced to do this up front.

conflicts will be materialised into [conflict markers](https://jj-vcs.github.io/jj/latest/conflicts/#conflict-markers), which look a bit different from git's.

### resolving conflicts

1. `new` - create a new commit on top of the conflicted one, and resolve the conflicts there. you can optionally `squash` the resolved commit back into the conflicted commit.

2. edit the conflicted commit directly using `jj edit`

3. use `jj resolve`

for more info see [Conflicts](https://jj-vcs.github.io/jj/latest/working-copy/#conflicts).

## [revsets](https://jj-vcs.github.io/jj/latest/revsets/)

`@` current revision.  
`@-` the parent (previous) revision.  
`@+` the child (next) revision.  
`::x` ancestors of x, including x.  
`z::` descendants of z, including z.
`heads(x)` within the set x, those commits that have no ancestors (they may have ancestors outside the set x).  
`heads(::@ & bookmarks())` intersection of ancestors of current revision and bookmarks, that are heads (ie: have no ancestors in this set).

"bookmark", "move", "--from", "heads(::@- & bookmarks())", "--to", "@-"

## split

selected changes are stored in parent commit

## squash

move a revision in whole or partially

`--revision` Squash the specified revision into its parent (shorthand for `--from REV --into REV-`).  
`--from` Specify one or more revisions (via a revset) whose changes are to be squashed.  
`--into` Specify the exact revision (commit) to receive the squashed changes.

## rebase

to reparent a revision and it descendants, eg:

```
jj rebase -s R1 -d R2
```

There are three different ways of specifying which revisions to rebase:

`--source/-s` to rebase a revision and its descendants.  
`--branch/-b` to rebase a whole branch, relative to the destination.  
`--revisions/-r` to rebase the specified revisions without their descendants.

If no option is specified, it defaults to `-b @`.

See [CLI reference: jj rebase](https://jj-vcs.github.io/jj/latest/cli-reference/#jj-rebase)

## limitations

- [no git hook support yet](https://github.com/jj-vcs/jj/discussions/403)
