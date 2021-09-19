# github apps

[Github Apps](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps) are recommended over OAuth apps because they have more fine-grained permissions and short-lived tokens (see [Reasons for switching to GitHub Apps](https://docs.github.com/en/developers/apps/getting-started-with-apps/migrating-oauth-apps-to-github-apps)), eg: OAuth Apps can act on all of the authenticated user's repositories, whereas GitHub Apps can be authorized for a single repo.

Github Apps can act on behalf of a user, using [user-to-server requests](https://docs.github.com/en/developers/apps/building-github-apps/identifying-and-authorizing-users-for-github-apps).
