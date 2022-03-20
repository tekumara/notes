# github apps

[Github Apps](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps) are recommended over OAuth apps because they have more fine-grained permissions and short-lived tokens (see [Reasons for switching to GitHub Apps](https://docs.github.com/en/developers/apps/getting-started-with-apps/migrating-oauth-apps-to-github-apps)).A GitHub app is locked down to issuing tokens with the permissions/scopes and repos it was created with, while an OAuth app allows creating tokens with any set of scopes and any repo.

Github Apps can act on behalf of a user, using [user-to-server requests](https://docs.github.com/en/developers/apps/building-github-apps/identifying-and-authorizing-users-for-github-apps).
