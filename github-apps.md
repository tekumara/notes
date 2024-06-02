# github apps

[Github Apps](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps) are recommended over OAuth apps because they have more fine-grained permissions and short-lived tokens, see [Reasons for switching to GitHub Apps](https://docs.github.com/en/developers/apps/getting-started-with-apps/migrating-oauth-apps-to-github-apps). A GitHub app is locked down to issuing tokens with the permissions/scopes and repos it was created with, while an OAuth app allows creating tokens with any set of scopes and any repo.

Some applications like the [GitHub CLI use an OAuth App](https://github.com/cli/cli/blob/be9f011/internal/authflow/flow.go) to generates tokens that can access many repos.

Github Apps can act on behalf of a user, using [user-to-server requests](https://docs.github.com/en/developers/apps/building-github-apps/identifying-and-authorizing-users-for-github-apps).

## private keys

The app has an RSA format (ie: PKCS #8) private key.

## installation vs user tokens

> Installation access tokens are used to make API requests on behalf of an app installation. User access tokens are used to make API requests on behalf of a user. Refresh tokens are used to regenerate user access tokens. Your app can use its private key to generate an installation access token. Your app can use its client secret to generate a user access token and refresh token.

([ref](https://docs.github.com/en/enterprise-cloud%40latest/apps/creating-github-apps/about-creating-github-apps/best-practices-for-creating-a-github-app#installation-access-tokens-user-access-tokens-and-refresh-tokens))

## Client IDs and application IDs

Client IDs and application IDs are not secrets. Application ids are publicly discoverable on the app's page.

Client IDs are now recommended used instead of application IDs to [fetch installation tokens](https://github.blog/changelog/2024-05-01-github-apps-can-now-use-the-client-id-to-fetch-installation-tokens).
