# github cli

Use ssh for github.dev.myorg.com

```
gh config set -h github.dev.myorg.com git_protocol ssh
```

Auth to github.dev.myorg.com using your browser, and store the generated oauth token on disk:

```
gh auth login -h github.dev.myorg.com -w
```

On macOS the [config dir is _~/.config/gh_](https://github.com/cli/cli/blob/25b6eecc8dd7845ca42afa3362b80b13c355356a/internal/config/config_file.go#L40)
