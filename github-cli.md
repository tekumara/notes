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

Sync the fork default branch (ie: master/main) with it's parent:

```
gh repo sync git@github.enterprise:tekumara/my-fork.git
```

This will update the fork on github, and fetch origin/main to match the parent repo. You'll need to merge your local branch with the origin.

## Authenticate Git with your GitHub credentials

During authentication you'll be asked `Authenticate Git with your GitHub credentials`?

[This feature](https://github.com/cli/cli/pull/2449) generates an oauth token, and stores it in the default git credential helper, eg: on Mac this is `credential-osxkeychain` which stores the token as a keychain item named after the hostname, eg: `github.com`

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
