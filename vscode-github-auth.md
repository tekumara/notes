# vscode-github-auth

VS Code has a built in Github Authentication process. It detects actions that require authentication to [https://github.com](https://github.com), including changing into a directory with a [https://github.com](https://github.com) repo, or cloning a new [https://github.com](https://github.com) URL in the terminal. If git credentials are missing for [https://github.com](https://github.com), it will use the GitHub for VSCode OAuth app to generate them.

On first usage, you'll be unauthenticated and asked to [authorise the GitHub for VSCode OAuth app](https://code.visualstudio.com/docs/editor/github#_authenticating-with-an-existing-repository) as follows:

1. VS Code will ask `The extension GitHub wants to sign in using GitHub`. Click `Allow`.
1. You'll be taken to a `https://vscode-auth.github.com/` authorization page. When asked `Authorize Visual Studio Code to access GitHub` click `Continue`.
1. If GitHub for VSCode has not already been authorised your account, you'll be asked to authorise it. Click `Authorise github`
1. On the Success page popup click `Open Visual Studio Code` to be taken back to VS Code.
1. When VS Code asks `Allow an extension to open this URI?` click `Allow`.

Once complete, the Github Authentication process generates two keychain items:

- `vscodevscode.github-authentication`: used by the VS Code Github Authentication process to generate session tokens.
- `github.com`: a session token used by `credential-osxkeychain`, the [macOS Keychain credential helper](https://docs.github.com/en/get-started/getting-started-with-git/updating-credentials-from-the-macos-keychain). This allows `git` commands to authenticate to [https://github.com](https://github.com) URLs as you.

The logs for the authentication process are visible in `Output - GitHub Authentication`.

## Signing out

In VS Code, click the profile icon in the bottom left. Choose your GitHub account and select `Sign out`.

This invalidates GitHub for VSCode credentials (ie: the `vscodevscode.github-authentication` keychain item) on your machine.

Note the GitHub for VSCode OAuth app will still be authorized. To revoke it, visit [Applications settings](https://github.com/settings/applications).

## macOS Keychain credentials

To fetch keychain creds:

```
echo | git credential-osxkeychain get
```

If the `github.com` keychain item is deleted, the VS Code Github Authentication process will regenerate it.

## Git Credential Manager

The [Git Credential Manager](https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git#git-credential-manager) is an alternative authenticator. Similar to VS Code, it requires authorising an OAuth app and uses that to generate credentials for your github.com user.
