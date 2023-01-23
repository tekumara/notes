# GitHub PRs

## Understanding the diff

The Github PR/compare page compares the differences between two branches in a repository. Specifically, it shows the set of commits on the compare branch that are not in the base branch. This set of commits is equivalent to [`git log base-ref..compare-ref`](git-log.md#ranges). The "Files changed" tab is diff shows the changes in this set of commits combined (and not changes from ancestors of a merge). There isn't a git cli command that can show a combined diff from a specific set of commits.

It's different from the "git diff" command which diffs the file tree at the tips of two branches.

Because of this, the Github PR/compare page may show changes that are already present in the base branch. This happens when the same changes are made in different commits, for example, commit A on the base branch and commit B on the compare branch. To resolve this, you can merge the base branch into the compare branch. This will effectively cancel out the differences made by commit B.
