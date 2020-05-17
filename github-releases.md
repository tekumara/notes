# GitHub Releases

GitHub Releases are tags that have artifacts associated with them. If you delete the tag for a release and it has artifacts, it will become a draft release.

## Troubleshooting

### error: src refspec refs/heads/master matches more than one

This happens when the [create-release action](https://github.com/actions/create-release) is configured like this:
```
with:
          tag_name: ${{ github.ref }}
```
If the release runs on the head of a branch (eg: master), then [`github.ref`](https://help.github.com/en/actions/configuring-and-managing-workflows/using-environment-variables#default-environment-variables) = `refs/heads/master`. Since the tag `refs/heads/master` doesn't exist, it will be created.

To [resolve](https://github.com/actions/create-release/issues/13#issuecomment-629741295):
```
git push origin :refs/tags/refs/heads/master
git tag -d refs/heads/master
```