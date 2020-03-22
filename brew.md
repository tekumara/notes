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

