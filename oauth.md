# oauth

## auth flows

There are different types of [flows](https://developer.okta.com/docs/concepts/oauth-openid/#choosing-an-oauth-2-0-flow):

- Interaction Code flow
- Client Credentials flow
- Authorization Code flow
- Authorization Code flow with PKCE
- etc.

Some of the OAuth Web application authorization flow requires callbacks, ie: something running on localhost listening for the callback. See [What's a Response Type](https://developer.okta.com/blog/2017/07/25/oidc-primer-part-1#whats-a-response-type)

OAuth Device authorization flow allows use of a one-time code ([example](https://github.com/cli/cli/pull/1522)). Useful for apps that don't have a web browser, eg: CLI tools.

## OIDC

OpenID Connect (OIDC) is built on OAuth 2.0 and results in an ID token, in addition to an access and refresh token.

OIDC provider = oauth auth server

### Step

`step oauth` will generate a access and id token locally, using the Google IDP to login to the Smallstep Step CLI app.

Other IDPs and apps can be used, but they need to allow localhost as a redirect URI.

## References

- [OAuth 2.0 and OpenID Connect Overview](https://developer.okta.com/docs/concepts/oauth-openid/)
- [Identity, Claims, & Tokens – An OpenID Connect Primer, Part 1 of 3](https://developer.okta.com/blog/2017/07/25/oidc-primer-part-1)
