# github apps

[Github Apps](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps) are recommended over OAuth apps because they have more fine-grained permissions and short-lived tokens (see [Reasons for switching to GitHub Apps](https://docs.github.com/en/developers/apps/getting-started-with-apps/migrating-oauth-apps-to-github-apps)).A GitHub app is locked down to issuing tokens with the permissions/scopes and repos it was created with, while an OAuth app allows creating tokens with any set of scopes and any repo.

Some applications like the [GitHub CLI use an OAuth App](https://github.com/cli/cli/blob/be9f011/internal/authflow/flow.go) to generates tokens that can access many repos.

Github Apps can act on behalf of a user, using [user-to-server requests](https://docs.github.com/en/developers/apps/building-github-apps/identifying-and-authorizing-users-for-github-apps).

## private keys

The app has an RSA format (ie: PKCS #8) private key.
