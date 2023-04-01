# Homebrew

Get info

`brew info javarepl` show formula info
`brew outdated` old formulas  
`brew reinstall <name>` reinstall/upgrade to latest version  
`brew uses --recursive --installed go` show all installed packages that require `go`
`brew log -p helm@2` show history of the helm@2 formula
`brew list coreutils` show all installed files of a keg
`brew tap caskroom/versions` Alternate cask versions
`brew search postgresql` Search installed taps for formulae and casks with `postgresql` in the name.

Show package owner of msbuild

```
ll `which msbuild`
```

## Brew update stalled

If after the first install of a packge, brew is stalled on "Updating Homebrew" run `brew update --debug --verbose` and wait until git syncs.

## Creating a formula

```
brew create https://github.com/glassechidna/awsweb/releases/download/0.1.7/awsweb_0.1.7_Darwin_x86_64.tar.gz
```

This will create a formula in _/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/awsweb.rb_

`brew install --debug foo` will ask you to open an interactive shell if the build fails so you can try to figure out what went wrong.

Use `brew info` and check if the version guessed by Homebrew from the URL is correct. Add an explicit version if not.

The url can be a git repo, in which case `:revision` is the git sha for `:tag`.

Other commands:
`brew audit --strict --online foo` to test formulae for adherence to Homebrew house style (will install gems on first run)
`brew audit --new-formula foo` foo highlights more potential issues than the standard audit.
`brew create https://example.com/foo-0.1.tar.gz` downloads the tar, creates a new formulae, and opens it in the editor

Docs:

- [Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [Class: Formula](https://www.rubydoc.info/github/Homebrew/brew/master/Formula)

### Troubleshooting

When copying an existing formula, remove the `bottle` block. This is added by the Homebrew CI system.
