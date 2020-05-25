# Homebrew

Search for taps via brew, and cask, will give different results, eg:
```
brew search java
brew cask search java
```

Get info
```
brew info javarepl
brew cask info java8
```

`brew cask outdated` old casks  
`brew cask reinstall <caskname>` reinstall/upgrade to latest version  
`brew tap caskroom/versions` Alternate cask versions

`brew uses --recursive go` show all packages that require `go`

Show package owner of msbuild
```
ll `which msbuild`
```

## Brew update stalled

If after the first install of cask, brew is stalled on "Updating Homebrew" run `brew update --debug --verbose` and wait until git syncs.

## Creating a formula

```
brew create https://github.com/glassechidna/awsweb/releases/download/0.1.7/awsweb_0.1.7_Darwin_x86_64.tar.gz
```

This will create a formula in */usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/awsweb.rb*

`brew install --verbose --debug foo` will ask you to open an interactive shell if the build fails so you can try to figure out what went wrong.

Use `brew info` and check if the version guessed by Homebrew from the URL is correct. Add an explicit version if not.

`brew audit --strict --online foo` to test formulae for adherence to Homebrew house style (will install gems on first run)
`brew audit --new-formula foo` foo highlights more potential issues than the standard audit.

Docs:
* https://docs.brew.sh/Formula-Cookbook#grab-the-url
* https://www.rubydoc.info/github/Homebrew/brew/master/Formula