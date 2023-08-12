# release please

Dry run locally, works off main branch on github:

```
npx release-please@latest release-pr --token=$(gh auth -h github.com token) --repo-url=tekumara/typos-vscode --dry-run
```

## PR remained the same

`ci` and `chore` commits on main won't update the PR.
Pushing to the release PR doesn't cause release please to run.

If you want to run release-please with new settings and the same set of commits, close the PR and run release please manually to recreate the PR.
