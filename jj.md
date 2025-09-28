# jj

> Powerful history-editing features, such as for splitting and squashing commits, for moving parts of a commit to or from its parent, and for editing the contents or commit message of any commit
> First-class conflicts means that conflicts won't prevent rebase, and existing conflicts can be rebased or rolled back

## vs git

In general jj has fewer concepts than git. The core ones are:

- [commit](https://jj-vcs.github.io/jj/latest/glossary/#commit) aka revision. A snapshot of the files in the repository at a given point in time.
- [change](https://jj-vcs.github.io/jj/latest/glossary/#change) - Changes provide stable identifiers even as the change (the commit) is amended or modified over time. A change ID is a property of a commit.
- the [working copy](https://jj-vcs.github.io/jj/latest/working-copy/) contains the files you are currently working on. Any file changes are automatically committed at the beginning of most `jj` commands.

Also has a better default diff viewer than git's default or diff-so-fancy.

### no staging area

jj doesn't have an explicit staging area or index. But they can be modelled using jj's concept by using the parent commit (`@-`) as your staging area. You can move changes from the workspace commit (`@`) to the staging area (`@-`) explicitly, like "git add". And you can "git commit" your staging area by creating a new commit above the staging area to create a new staging area.

[ref](https://news.ycombinator.com/item?id=44657764)

No concept of untracked changes see [#5225](https://github.com/jj-vcs/jj/issues/5225#issuecomment-2868938712)

### no working branch

> jj commands will usually put the git repo in a "detached HEAD" state, since in jj there is not concept of a "currently tracked branch"

No concept of working branch see [#2425](https://github.com/jj-vcs/jj/discussions/2425) - so some people just [edit the one change](https://github.com/jj-vcs/jj/discussions/2425#discussioncomment-9193689) and force push that. See also the [experimental advance-branches](https://github.com/jj-vcs/jj/discussions/3549) features.

### see also

For more see [Comparison with Git](https://jj-vcs.github.io/jj/latest/git-comparison/).

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

More info: see [arguments for auto snapshotting](https://github.com/jj-vcs/jj/issues/323#issuecomment-2571760838).

## ignore

To ignore a file (eg: uv.lock) in the working copy:

```
echo uv.lock >> .gitignore
jj file untrack uv.lock
```

Ideally this would be a one-liner, see [#3493](https://github.com/jj-vcs/jj/issues/3493).

## blame

To blame each line in pyproject.toml:

```
jj file annotate pyproject.toml
```

## bookmarks

Bookmarks are named pointers to commits, like branches in git.

Running `jj bookmark track ...` sets a local bookmark to follow its remote counterpart (upstream), so future `jj git fetch` updates will automatically fast‑forward your local bookmark when the remote moves.

Track a specific bookmark: `jj bookmark track main@origin`

A `*` suffix on a bookmark means that the local bookmark and its corresponding remote bookmark (such as main@origin) point to different commits.

A `??` suffix will show on multiple revisions for a bookmark when its conflicted. `jj bookmark list <name>` or `jj bookmark list -c` will describe the conflict. Using the bookmark name to look up a revision will resolve to all potential targets. See [Bookmarks - Conflicts](https://jj-vcs.github.io/jj/latest/bookmarks/#conflicts)

`jj bookmark set` will create or update a single bookmark.
`jj bookmark move` will move a set of existing bookmarks to a revision

Use either to resolve a conflict.

Because jj operates in a detacted head state, moving bookmarks backwards doesn't hide the previous tip in the log.

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

Selected changes are stored in parent revision, unless the parent revision is immutable then a new parent revision is created.

## squash

move a revision in whole or partially

`--revision` Squash the specified revision into its parent (shorthand for `--from REV --into REV-`).  
`--from` Specify one or more revisions (via a revset) whose changes are to be squashed.  
`--into` Specify the exact revision (commit) to receive the squashed changes.

`jj squash` will move current rev (working copy) into parent.

## diffedit

choose what to keep in a revision

## restore

`jj restore` will drop all file changes in current revision, like `git checkout --` drops unstaged changes

## rebase

to reparent a revision `r1` and it descendants, eg:

```
jj rebase -s r1 -d r2
```

to remove a parent, eg: if `r1` has two parents `p1` and `p2` this removes parent `p2`

```
jj rebase -s r1 -d p1
```

There are three different ways of specifying which revisions to rebase:

`--source/-s` to rebase a revision and its descendants.  
`--branch/-b` to rebase a whole branch, relative to the destination.  
`--revisions/-r` to rebase the specified revisions without their descendants.

If no option is specified, it defaults to `-b @`.

See [CLI reference: jj rebase](https://jj-vcs.github.io/jj/latest/cli-reference/#jj-rebase)

## limitations

- [no git hook support yet](https://github.com/jj-vcs/jj/discussions/403)
