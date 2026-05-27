# jj-spr

## Incorporating commits added directly to a GitHub PR

`jj-spr` treats one local Jujutsu change as the source of truth for the PR's final content.

If someone pushes commits directly to the GitHub PR branch, fold their resulting content into the original local JJ change before running `jj spr diff` again.

At a high level:

1. Fetch the GitHub PR branch.
2. Apply its intended content to the original JJ change.
3. Resolve any conflicts caused when JJ rebases descendant changes.
4. Confirm the original local change and GitHub PR head have the same tree.
5. Run `jj spr diff` only for descendant changes whose rebased content needs to be appended to their GitHub PRs. The original PR needs no update once its trees match.

Example:

```sh
jj git fetch
jj log -r 'spr/refactor-remove-mention-of-dsl@origin'

jj restore \
  --from 'spr/refactor-remove-mention-of-dsl@origin' \
  --into <original-change-id> \
  architecture/platform.md

# Verify the original PR only; this should report "No update necessary".
jj spr diff -r <original-change-id> --dry-run

# Verify the complete stack.
jj spr diff -all --dry-run

# Publish only a descendant whose individual dry run reports an update.
# Without -m you'll be prompted for a message for the commit.
jj spr diff -r <descendant-change-id> -m "Rebase after incorporating PR edits"
```


Rewriting an older JJ change automatically rebases its descendants. If that introduces conflicts, resolve them in the affected descendant and squash the resolution into it:

```sh
jj new <conflicted-change-id>
# Edit the conflicted files.
jj squash
```

The GitHub commits remain separate in the PR's review history. Locally, their content is folded into the original single JJ change rather than represented as separate JJ changes.

Do not run `jj spr diff` before reconciling external GitHub edits. SPR will build a new GitHub commit from the local JJ tree, which can effectively undo changes that exist only on GitHub.


### Range mode

Range mode is for processing a complete stack. Use trunk as its lower boundary:

```sh
jj spr diff -r 'main@origin..<last-stack-change>' --dry-run
```

After the reconciliation in this example, running the trunk-based range through the last descendant checked PRs #33 through #40 and correctly reported `No update necessary` for all of them.

Do not use an internal stack change as the lower boundary, such as `svmz..lsmy`. In the current implementation, range mode treats the parent of the first included change as the stack's main base. An internal boundary can therefore produce a false-positive update even when an individual revision check reports `No update necessary`.

Do not include an empty working-copy revision at the top of the range; it has no title and causes `Commit message does not have a title!`. Target the last described stack change instead.
