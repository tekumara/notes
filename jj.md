# jj

> Powerful history-editing features, such as for splitting and squashing commits, for moving parts of a commit to or from its parent, and for editing the contents or commit message of any commit.

> First-class conflicts means that conflicts won't prevent rebase, and existing conflicts can be rebased or rolled back.
> Being able to pick and choose where modifications go makes it easier to be intentional about where something belongs.

> more mindful about where any particular code changes “belongs”. It’s easy to put things in the right place, and to build a commit or change series that’s a logical and well-encapsulated series of discrete steps.

> jj encourages a rebase-friendly workflow, given how easy it is to rebase and rearrange things at any time. This is somewhat incompatible with forges2 like GitHub, where force pushes invalidate review comments in pull requests.

super easy to do fixups

## vs git

In general jj has fewer concepts than git. The core ones are:

- [commit](https://jj-vcs.github.io/jj/latest/glossary/#commit). A snapshot of the files in the repository at a given point in time.
- [change](https://jj-vcs.github.io/jj/latest/glossary/#change) - a stable identifier that can is amended or modified over time to point at a different commits. A change identifier is a property of a commit. Conceptually, changes are like branches in that they provide a pointer to a logical groups of commits that evolve over time.
- revision - synonymous with commit according to the glossary. Note that a revision CLI argument can be a commit id, change id, bookmark or symbol, see [revsets](https://jj-vcs.github.io/jj/latest/revsets/).
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

## config

To unset a config value use `JJ_CONFIG=/dev/null jj <command>` to ignore all config files.

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

Bookmarks are named pointers to commits, like tags in git. ie: they don't automatically move as new commits are made.

NB: There is an [experimental feature](https://github.com/jj-vcs/jj/discussions/3549) that advances a bookmark forward on `jj commit` or `jj new`

Running `jj bookmark track ...` sets a local bookmark to follow its remote counterpart (upstream), so future `jj git fetch` updates will automatically fast‑forward your local bookmark when the remote moves.

Track a specific bookmark: `jj bookmark track main@origin`

A `*` suffix on a bookmark means that the local bookmark and its corresponding remote bookmark (such as main@origin) point to different commits.

A `??` suffix will show on multiple revisions for a bookmark when its conflicted. `jj bookmark list <name>` or `jj bookmark list -c` will describe the conflict. Using the bookmark name to look up a revision will resolve to all potential targets. See [Bookmarks - Conflicts](https://jj-vcs.github.io/jj/latest/bookmarks/#conflicts)

`jj bookmark set` will create or update a single bookmark.
`jj bookmark move` will move a set of existing bookmarks to a revision

Use either to resolve a conflict.

Because jj operates in a detacted head state, moving bookmarks **backwards** doesn't hide the previous tip in the log (unlike branches in git).

To remove bookmarks use:

- `delete` will be proagated to remotes on next push
  -``forget` won't be propagated to remotes, just removed locally

## push

To create a name implicitly on push

```
jj git push -c @
```

## conflicts

[Conflicts](https://jj-vcs.github.io/jj/latest/conflicts/) are stored logically inside commits. They can be postponed until you need to resolve, you aren't forced to do this up front.

Conflicts will be materialised into [conflict markers](https://jj-vcs.github.io/jj/latest/conflicts/#conflict-markers), which look a bit different from git's.

Conflicts can be generated on `jj git fetch` when a branch is merged and is deleted on the remote, eg: if `trunk-based` is deleted on the remote, then `wxko` and `rpxp` will be abandoned, and descendants rebased, which can cause a conflict in `uwys` if the abandoned commits contained conflict resolutions changes.

```
○ │  uwys tekumara 2025-09-23 21:57:10 80da
├─╯  cruft update
○  wxko tekumara 2025-09-23 21:44:54 trunk-based ca33
│  update contributing
○  rpxp tekumara 2025-09-23 20:25:41 23e5
│  require pytest-mock
○  npvu tekumara 2025-09-23 20:10:27 del-me ffb2
```

### resolving conflicts

1. `new` - create a new commit on top of the conflicted one, and resolve the conflicts there. you can optionally `squash` the resolved commit back into the conflicted commit.

2. edit the conflicted commit directly using `jj edit`

3. use `jj resolve` or edit the conflict markers in the conflicted file directly with a text editor, or in a merge tool like VS Code.

For more info see [Conflicts](https://jj-vcs.github.io/jj/latest/working-copy/#conflicts).

#### Conflict markers

`jj` uses a hybrid conflict marker style by default:

- Side 1 is shown as a **diff** from the base (what changed).
- Side 2 is shown as a **snapshot** (the full content).

Example:

```
<<<<<<<
%%%%%%% Changes from base to side #1
-grape
+grapefruit
+++++++ Contents of side #2
GRAPE
>>>>>>>
```

- `%%%%%%%` section: `-grape` means "grape" was removed in side 1. `+grapefruit` means "grapefruit" was added.
- `+++++++` section: `GRAPE` is the content in side 2.

To resolve these using `jj resolve` select the everything you want to apply to the base. In the above example if you just select `+GRAPE`, you still have `grape` from the base. So if you want side 2, select `-grape` and `+GRAPE`.

### How do I deal with divergent changes ('??' after the change ID)?

This happens when editing a change that has been pushed to the remote.
Or, when fetching changes from the remote, and there are local changes too.

To keep both changes, [generate a new change id](https://docs.jj-vcs.dev/latest/guides/divergence/#strategy-2-generate-a-new-change-id):

```
jj metaedit --update-change-id <commit-id>
```

## [revsets](https://jj-vcs.github.io/jj/latest/revsets/)

`@` current revision.  
`@-` the parent (previous) revision.  
`@+` the child (next) revision.  
`::x` ancestors of x, including x (ie: branches ending in x)  
`x::` descendants of x, including x.
`x..` Revisions that are not ancestors of x, ie: not on the branch that ends with x (inclusive), eg: `main@origin..` are commits not in branch main@origin. `main..@` will show commits on the current branch until main, ie: that are ancestors of `@` but not ancestors of main. `main..` shows all commits not on `main`, so it can include changes from other branches, not just your current one.
`heads(x)` within the set x, those commits that have no ancestors (they may have ancestors outside the set x).  
`heads(::@ & bookmarks())` intersection of ancestors of current revision and bookmarks, that are heads (ie: have no ancestors in this set), eg: "bookmark", "move", "--from", "heads(::@- & bookmarks())", "--to", "@-"
`::` or `all()` all commits

[Built-in aliases](https://jj-vcs.github.io/jj/latest/revsets/#built-in-aliases):

`trunk()` is head of default bookmark for default remote, eg: main@origin
`immutable_heads()` is `present(trunk()) | tags() | untracked_remote_bookmarks()` ie: all the tips on origin.
`immutable_heads()..` local bookmarks and commits not on trunk

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

`jj restore -f [filesets]` will revert files in filesets to main.

## rebase

to reparent a revision `r1` and it descendants to `d2`, eg:

```
jj rebase -s r1 -d r2
```

with multiple parents:

```
jj rebase -s r1 -d r2 -d r3
```

to remove a parent, eg: if `r1` has two parents `p1` and `p2` this removes parent `p2`

```
jj rebase -s r1 -d p1
```

to merge main into the current revision we rebase `@` onto its existing parent (`@-`) and main:

```
jj rebase -d @- -d main
```

There are three different ways of specifying which revisions to rebase:

`--source/-s` to rebase a revision and its descendants.  
`--branch/-b` to rebase a whole branch, relative to the destination.  
`--revisions/-r` to rebase the specified revisions without their descendants.

If no option is specified, it defaults to `-b @`.

See [CLI reference: jj rebase](https://jj-vcs.github.io/jj/latest/cli-reference/#jj-rebase)

## workspaces

If you accidentally delete the default workspace it will get recreated.

## limitations

- [no git hook support yet](https://github.com/jj-vcs/jj/discussions/403)

## references

- [What I've learned from jj](https://zerowidth.com/2025/what-ive-learned-from-jj/)
