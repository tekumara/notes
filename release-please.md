# release please

Bootstrap config files:

```
npx release-please@latest bootstrap --token=$(gh auth -h github.com token) --repo-url=tekumara/fakesnow --release-type=python --dry-run
```

Dry run locally, works off main branch on github:

```
npx release-please@latest release-pr --token=$(gh auth -h github.com token) --repo-url=tekumara/typos-vscode --dry-run
```

## Config file

See the options and their defaults [here](https://github.com/googleapis/release-please/blob/main/docs/manifest-releaser.md#configfile).

Whilst < 1.0.0 to [bump minor for breaking changes](https://github.com/googleapis/release-please/blob/611db3d5628d1ff4cd7c40259894daf0c13f8e17/docs/manifest-releaser.md?plain=1#L167), and [bump patch for new features](https://github.com/googleapis/release-please/blob/611db3d5628d1ff4cd7c40259894daf0c13f8e17/docs/manifest-releaser.md?plain=1#L171) set:

```json
  "bump-minor-pre-major": true,
  "bump-patch-for-minor-pre-major": true,
```

## PR remained the same

`ci` and `chore` commits on main won't update the PR, unless they have been [explicitly configured to via changelog-sections](https://github.com/tekumara/fakesnow/blob/966cc92f9e753698e14c67a03b1cf2110bc9507b/release-please-config.json#L4). See the [changelog section defaults](https://git.io/JqCZL).

Pushing to the release PR doesn't cause release-please to run.

If you want to run release-please with new settings and the same set of commits, close the PR and run release-please manually (eg: rerun the workflow or run the cli) to recreate the PR. The old PR needs to be closed because Release Please will not create a new PR if there's an existing one labelled as `autorelease: pending`.

See also [Release Please bot does not create a release PR. Why?](https://github.com/googleapis/release-please?tab=readme-ov-file#release-please-bot-does-not-create-a-release-pr-why)

## Retriggering failed release

Without updating changelog:

1. Delete the existing tag. This will reset the release to a draft release.
1. Push a commit that fixes the build.
1. On the draft release set the new commit as the tag target and then click publish release.

If you wish to regenerate the release notes then:

1. Delete the release.
1. Delete the tag.
1. Revert the commit that bumped the version and updated CHANGELOG.md.
1. Push a commit that fixes the build.
