# github cli

Use ssh for github.dev.myorg.com

```
gh config set -h github.dev.myorg.com git_protocol ssh
```

Auth to github.dev.myorg.com using your browser, ssh for git, and store the generated oauth token on disk:

```
gh auth login -h github.dev.myorg.com -w -p ssh
```

On macOS the [config dir is _~/.config/gh_](https://github.com/cli/cli/blob/25b6eecc8dd7845ca42afa3362b80b13c355356a/internal/config/config_file.go#L40). Oauth tokens are stored here.

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

`gh auth git-credential` implements the [git credential helper interface](https://github.com/cli/cli/blob/6701b52/pkg/cmd/auth/gitcredential/helper.go), eg:

To fetch creds:

```
echo | gh auth git-credential get
```

To use this with git:

```
gh auth setup-git [<hostname>]
```

For more info see [https://github.com/cli/cli/pull/4246](https://github.com/cli/cli/pull/4246)

## Troubleshooting

> can't find corresponding remote for apache/spark

To resolve, and sync the local repository from the remote parent, change the default repo to match the origin remote:

```
❯ gh repo set-default tekumara/spark
✓ Set tekumara/spark as the default repository for the current directory
❯ gh repo sync
✓ Synced the "main" branch from tekumara/spark to local repository
```

> could not compute title or body defaults: failed to run git: fatal: ambiguous argument 'upstream/... ': unknown revision or path not in the working tree.

Fetch the remote first:

```
git fetch upstream
```

See [#5896 comment](https://github.com/cli/cli/issues/5896#issuecomment-1304723277)

> can't determine source repository for tobymao/sqlglot because repository is not fork

Don't specify the upstream repo when running gh sync, use your fork instead, eg:

```
gh repo sync tekumara/sqlglot
```
