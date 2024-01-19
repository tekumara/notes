# 1password

Unique features:

- remembers how you signed into sites using SSO rather than password
- unlock vault via TouchId on Mac
- can share vault items via a link with folks who don't have 1password
- can input password into desktop apps
- uses a secret key + password to lock vault - means password key logging is insufficient
- supports passkeys across browsers and devices

## Private keys

The 1password desktop app will return private keys in OpenSSH format.

But the `op` cli returns them in RSA format (ie: PKCS #8).

See [this discussion](https://1password.community/discussion/comment/672965/#Comment_6729655).

## Usage

Read private key in PKCS #8 format:

```
op read op://Personal/awesome.private-key/'Private Key'
```

## Connecting to other Browsers

`Settings -> Browser -> Add Browser` this allows browsers that have the extension installed to access the 1password native app. Without this, the browser extension can still access the vault but it needs to do an unlock itself.
