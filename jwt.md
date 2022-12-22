# jwt

Install [python-jose](https://github.com/mpdavis/python-jose):

```shell
pip install 'python-jose[cryptography]'
```

Get unverified header:

```python
jwt.get_unverified_header(token)
{'kid': 'abcedf1234567890', 'alg': 'RS256'}
```

Get unverified payload

```python
jwt.get_unverified_claims(token)
# example access token see https://developer.okta.com/docs/reference/api/oidc/#access-token-payload
{'ver': 1, 'jti': 'AT.0mP4JKAZX1iACIT4vbEDF7LpvDVjxypPMf0D7uX39RE"', 'iss': 'https://{yourOktaDomain}/oauth2/{authorizationServerId}', 'aud': 'https://api.example.com', 'iat': 1671333952, 'exp': 1671420352, 'cid': 'nmdP1fcyvdVO11AL7ECm', 'uid': '00ujmkLgagxeRrAg20g3', 'scp': ['openid', 'profile', 'email'], 'auth_time': 1670654985, 'sub': 'baby.yoda@space.com'}

# example id token see https://developer.okta.com/docs/reference/api/oidc/#id-token-payload
```

One-liner decode stdin:

```
pbpaste | python -c 'import sys,json; token = sys.stdin.read(); from jose import jwt; print(json.dumps(jwt.get_unverified_headers(token))); print(json.dumps(jwt.get_unverified_claims(token)))'
```

## References

- [JSON Web Token (JWT)](https://www.rfc-editor.org/rfc/rfc7519)
- [JSON Web Key (JWK)](https://www.rfc-editor.org/rfc/rfc7517) see [kid](https://www.rfc-editor.org/rfc/rfc7517#section-4.5) and [alg](https://www.rfc-editor.org/rfc/rfc7517#section-4.4)
