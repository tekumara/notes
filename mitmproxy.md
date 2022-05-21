# mitmproxy

Install:

```
brew install mitmproxy
```

Install the [mitmproxy cert](https://docs.mitmproxy.org/stable/concepts-certificates/#installing-the-mitmproxy-ca-certificate-manually):

```
sudo security add-trusted-cert -d -p ssl -p basic -k /Library/Keychains/System.keychain ~/.mitmproxy/mitmproxy-ca-cert.pem
```

Run the proxy:

```
mitmproxy
```

Test:

```
curl --proxy 127.0.0.1:8080 --cacert ~/.mitmproxy/mitmproxy-ca-cert.pem https://example.com/
```

To use with a [python requests](https://github.com/mitmproxy/mitmproxy/issues/2547#issuecomment-399778481):

```
HTTPS_PROXY=http://127.0.0.1:8080 REQUESTS_CA_BUNDLE=~/.mitmproxy/mitmproxy-ca-cert.cer python -c 'import requests; requests.get("https://example.com")
```

## TUI

flows:

- `d` delete flow
- `enter` show flow
- `:` `export.clip curl @focus` copy flow request to [clipboard as curl command](https://github.com/mitmproxy/mitmproxy/issues/2649#issuecomment-392342343).

flow details:

- `r` replay flow
- `q` exit flow

global:

- `B` start an attached browser proxying via mitmproxy

## Useful key bindings

Add the following to _~/.mitmproxy/keys.yaml_:

```
 -
   key: c
   cmd: export.clip curl @focus
   help: Export a flow as a curl command to the clipboard.
```
