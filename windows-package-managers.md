# windows package managers

## scoop

- installs as user by default, better architecture

### Install

Install the [Scoop package manager](https://scoop.sh/) from Powershell (eg: Windows Terminal):

```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
irm get.scoop.sh | iex
```

Not recommended to run this as admin user but if you must [see here](https://github.com/ScoopInstaller/Install#for-admin).

To install git:

```
scoop install main/git
```

## chocolatey

- installs as admin by default
- more popular and is shipped inside other tools like nodejs and github actions
- has more packages than scoop, including arm64 packages
- has official `main` packages and [community maintained packages](https://community.chocolatey.org/packages)

## winget

- official [Windows Package Manager](https://learn.microsoft.com/en-us/windows/package-manager/winget/) available in Windows 10+
- integrated with Windows Store
- installs as user, eg: for standalone exes these go into C:\Users\USERNAME\AppData\Local\Microsoft\WinGet\Links\
- similar number of unique packages to chocolatey, see [winstall.app](https://winstall.app/)
