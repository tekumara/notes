# Windows setup

A basic Windows 10 setup with the Windows SDK, scope, rust needs ~50 GB.

## Create a non-admin user

Settings - Accounts - Other Users - Add account - I don't have this person's sign-in information - Add a user without a Microsoft account

## Installs

Install the [Scoop package manager](https://scoop.sh/) from Powershell (eg: Windows Terminal):

```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
irm get.scoop.sh | iex
```

Not recommended to run this as admin user but if you must [see here](https://github.com/ScoopInstaller/Install#for-admin).

Git:

```
scoop install main/7zip main/git
```
