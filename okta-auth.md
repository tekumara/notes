# Okta Authorization Code flow with PKCE with OIDC scopes

From the perspective of the [client](https://github.com/okta/okta-auth-js#example-client):

```javascript
var config = {
  // see https://github.com/okta/okta-auth-js#about-the-issuer
  issuer: "https://{yourOktaDomain}/oauth2/custom-auth-server-id",
  clientId: "GHtf9iJdr60A9IYrR0jw",
  redirectUri: "https://acme.com/oauth2/callback/home",
};

var authClient = new OktaAuth(config);
```

Example OIDC token request:

1. [/.well-known/openid-configuration](https://developer.okta.com/docs/reference/api/oidc/#well-known-openid-configuration): `https://{yourOktaDomain}/oauth2/custom-auth-server-id/.well-known/openid-configuration`
1. [/authorize](https://developer.okta.com/docs/reference/api/oidc/#authorize) with the openid scope: `https://{yourOktaDomain}/oauth2/custom-auth-server-id/v1/authorize?client_id=GHtf9iJdr60A9IYrR0jw&code_challenge=....&code_challenge_method=S256&nonce=....&redirect_uri=https%3A%2F%2Facme.com%2Foauth2%2Fcallback/home&response_type=code&state=...&scope=openid%20profile%20email`.

   This will respond with a 302 redirect to the redirect_uri and append `code` and `state` params. `state` is the same value as sent in the request and is used to avoid CSRF. `code` is an opaque used to redeem tokens from the token endpoint.

1. [/token](https://developer.okta.com/docs/reference/api/oidc/#token): `https://{yourOktaDomain}/oauth2/$appid/v1/token` using form data containing `code` and `code_verifier`. Response body will contain an access token for the resource server, and an OIDC token.
1. [/keys](https://developer.okta.com/docs/reference/api/oidc/#keys): `https://{yourOktaDomain}/oauth2/$appid/v1/keys` get the JWKS with public keys to verify the signatures of tokens received from the authorization server.

## Session tokens

When authorizing, if a Okta session token is provided, re-authentication will be skipped if the user has already authenticated.
The Okta session is stored as the `sid` cookie on your okta domain, and if it exists it'll be passed on the /authorize https request.

After you've obtained a `sessionToken` from the authorization flows, or a session already exists, you can obtain a token or tokens without prompting the user to log in using [token.getWithoutPrompt](https://github.com/okta/okta-auth-js#tokengetwithoutpromptoptions).

## References

- [Authorization Code flow with PKCE](https://developer.okta.com/docs/concepts/oauth-openid/#authorization-code-flow-with-pkce):
- [okta/okta-auth-js](https://github.com/okta/okta-auth-js)
