# github cli

Use ssh for github.dev.myorg.com

```
gh config set -h github.dev.myorg.com git_protocol ssh
```

Auth to github.dev.myorg.com using your browser, ssh for git, and upload your SSH key:

```
gh auth login -h github.dev.myorg.com -w -p ssh
```

On macOS the [config dir is _~/.config/gh_](https://github.com/cli/cli/blob/25b6eecc8dd7845ca42afa3362b80b13c355356a/internal/config/config_file.go#L40). Oauth tokens are stored in the Login keychain under `gh:github.com` or your GHE hostname.

If `GITHUB_TOKEN` or `GITHUB_ENTERPRISE_TOKEN` env vars are specified they'll take precedence over stored oauth tokens.

Sync the fork default branch (ie: master/main) with its parent:

```
# ghe
gh repo sync git@github.enterprise:tekumara/repo.git

# github.com
gh repo sync tekumara/repo
```

This will update the fork on github. You can then pull the changes to your local repo.

Create a PR against the parent repo, rather then the fork:

```
gh pr create --fill -w -R parent/repo
```

## Usage

Create org repo:

```
gh api orgs/ORG/repos -F name=REPO -F allow_merge_commit=false -F allow_rebase_merge=false -F squash_merge_commit_message=PR_BODY -F squash_merge_commit_title=PR_TITLE
```

NB: This will return 404 when ORG = a user name. Use `gh api user/repos` instead.

Update repo, eg: set `delete_branch_on_merge`:

```
gh api repos/OWNER/REPO -F delete_branch_on_merge=true
```

## Authenticate Git with your GitHub credentials

During authentication you'll be asked `Authenticate Git with your GitHub credentials`?

[This feature](https://github.com/cli/cli/pull/2449) generates an oauth token, and stores it in the default git credential helper, eg: on Mac this is `credential-osxkeychain` which stores the token as a keychain item named after the hostname, eg: `github.com`

This token can be revoked by revoking the Github CLI [OAuth App](https://github.com/settings/applications).

## GitHub CLI as git credential helper

`gh auth git-credential` [implements](https://github.com/cli/cli/blob/6701b52/pkg/cmd/auth/gitcredential/helper.go), the [git crendtial helper interface](https://git-scm.com/docs/gitcredentials) for supplying HTTP usernames/passwords eg:

To fetch creds:

```
echo -e "host=github.com\nprotocol=https" | gh auth git-credential get
# or
gh auth token
```

To fetch just the token:

```
gh auth token
```

To use this with git:

```
gh auth setup-git [<hostname>]
```

This adds the following to _~/.gitconfig_:

```
credential.https://github.com.helper=
credential.https://github.com.helper=!/opt/homebrew/bin/gh auth git-credential
credential.https://gist.github.com.helper=
credential.https://gist.github.com.helper=!/opt/homebrew/bin/gh auth git-credential
```

For more info see [https://github.com/cli/cli/pull/4246](https://github.com/cli/cli/pull/4246)

## Default remote repository

Set the default remote repository for the current directory:

```
gh repo set-default
```

This will be saved in _.git/config_ as the key value pair `gh-resolved = base` under the remote you select.

## Sync

Sync the `main` branch in the local repo with the default remote repo:

```
gh repo sync
```

Synch the fork tekumara/PyGithub from it's parent

```
gh repo sync tekumara/PyGithub
```

## Multi-user

Use direnv to [set an alternate GH_CONFIG_DIR](https://github.com/cli/cli/issues/326#issuecomment-847810959) and [auth using insecure storage](https://github.com/cli/cli/issues/326#issuecomment-1641389115):

```
gh auth login -h github.com -w --insecure-storage
```

This will store and use the token in _$GH_CONFIG_DIR/hosts.yml_.

Use `gh auth status` to verify it works after changing directories.

## Troubleshooting

#### can't find corresponding remote for apache/spark

To resolve, and sync the local repository from the remote parent, change the default repo to match the origin remote:

```
❯ gh repo set-default tekumara/spark
✓ Set tekumara/spark as the default repository for the current directory
❯ gh repo sync
✓ Synced the "main" branch from tekumara/spark to local repository
```

#### could not compute title or body defaults: failed to run git: fatal: ambiguous argument 'upstream/... ': unknown revision or path not in the working tree

Fetch the remote first:

```
git fetch upstream
```

See [#5896 comment](https://github.com/cli/cli/issues/5896#issuecomment-1304723277)

#### can't determine source repository for tobymao/sqlglot because repository is not fork

Don't specify the upstream repo when running gh sync, use your fork instead, eg:

```
gh repo sync tekumara/sqlglot
```

#### HTTP 404: Not Found (<https://api.github.com/repos/PyGithub/PyGithub/merge-upstream>)

You've tried to sync a remote repo that does not have an upstream, ie: is not a fork.
eg: `gh repo sync PyGithub/PyGithub`

#### could not compute title or body defaults: could not find any commits between master and master

If you are trying to raise a PR against the upstream repo make sure you have it as a remote:

```
git remote add upstream https://github.com/landaire/png-crc-fix.git
git fetch upstream
```

#### can't sync because main is not tracking PyGithub/PyGithub

You've tried to sync a local branch that is not tracking the default remote repository.
eg: `gh repo sync` on a local repo cloned from a fork of, rather than, the default remote repository.

#### can't sync because there are diverging changes; use `--force` to overwrite the destination branch

You destination repo is ahead of the source repo so a fast-forward merge is not possible.
`--force` will use a hard reset to do the merge, which will overwrite the commits that are ahead.
Prefer a manual conflict resolution, eg:

```
git pull upstream
git merge upstream/main
```

#### PUT https://api.github.com/organizations/123/team/456/repos/my-org/my-repo: 422 Validation Failed

Check permissions as per the [api docs](https://docs.github.com/en/rest/teams/teams?apiVersion=2022-11-28#add-or-update-team-repository-permissions).

<!-- markdownlint-disable-file MD001 -->
