# GitHub PRs

## Understanding the diff

The Github PR/compare page compares the differences between two branches in a repository. Specifically, it shows the set of commits on the compare branch that are not in the base branch. This set of commits is equivalent to [`git log base-ref..compare-ref`](git-log.md#ranges). The "Files changed" tab diff shows the changes in this set of commits combined (and not changes from ancestors of a merge). NB: there isn't a git cli command that can show this, ie: a combined diff from a specific set of commits. The `git diff` command diffs the file tree at the tips of two branches.

Because of this, the Github PR/compare page may show changes that are already present in the base branch. This happens when the same changes are made in different commits, for example, commit A on the base branch and commit B on the compare branch. To resolve this, you can merge the base branch into the compare branch. This will effectively cancel out the differences made by commit B.

> If you want to simulate a two-dot diff in a pull request and see a comparison between the most recent versions of each branch, you can merge the base branch into your topic branch, which updates the last common ancestor between your branches.

See [About comparing branches in pull requests - Two-dot Git diff comparison](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-comparing-branches-in-pull-requests#three-dot-and-two-dot-git-diff-comparisons:~:text=If%20you%20want%20to%20simulate%20a%20two%2Ddot%20diff%20in%20a%20pull%20request%20and%20see%20a%20comparison%20between%20the%20most%20recent%20versions%20of%20each%20branch%2C%20you%20can%20merge%20the%20base%20branch%20into%20your%20topic%20branch%2C%20which%20updates%20the%20last%20common%20ancestor%20between%20your%20branches)
