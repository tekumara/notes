# github cli

Use ssh for github.dev.myorg.com

```
gh config set -h github.dev.myorg.com git_protocol ssh
```

Auth to github.dev.xero.com using your browser, and store the generated oauth token on disk:

```
gh auth login -h github.dev.myorg.com -w
```

On macOS the [config dir is _~/.config/gh_](https://github.com/cli/cli/blob/25b6eecc8dd7845ca42afa3362b80b13c355356a/internal/config/config_file.go#L40). Oauth tokens are stored here.

If `GITHUB_TOKEN` or `GITHUB_ENTERPRISE_TOKEN` env vars are specified they'll take precedence over stored oauth tokens.

Sync the fork with it's parent

```
gh repo sync git@github.enterprise:tekumara/awesome-app.git
```
