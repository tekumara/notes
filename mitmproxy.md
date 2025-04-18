# mitmproxy

Install:

```
brew install mitmproxy
```

Run the proxy:

```
mitmproxy
```

Or run as a SOCKS proxy:

```
mitmproxy --mode socks5
```

Then point the SOCKS client at localhost:1080.

## Cert

Clients need to [trust the mitmproxy CA](https://docs.mitmproxy.org/stable/concepts-certificates/#installing-the-mitmproxy-ca-certificate-manually). Some clients can be provided with the cert, for example when using curl:

```
curl --proxy 127.0.0.1:8080 --cacert ~/.mitmproxy/mitmproxy-ca-cert.pem https://example.com/
```

To use with [python requests](https://github.com/mitmproxy/mitmproxy/issues/2547#issuecomment-399778481):

```
HTTPS_PROXY=http://127.0.0.1:8080 REQUESTS_CA_BUNDLE=~/.mitmproxy/mitmproxy-ca-cert.cer python -c 'import requests; requests.get("https://example.com")
```

To add to the JVM keystore:

```
sudo keytool -importcert -alias mitmproxy -storepass changeit -keystore $JAVA_HOME/lib/security/cacerts -trustcacerts -file ~/.mitmproxy/mitmproxy-ca-cert.pem
```

To install as a [system cert](#system-cert), for use by browsers etc:

```
sudo security add-trusted-cert -d -p ssl -p basic -k /Library/Keychains/System.keychain ~/.mitmproxy/mitmproxy-ca-cert.pem
```

## TUI

flows:

- `d` delete flow
- `enter` show flow
- `:` `export.clip curl @focus` copy flow request to [clipboard as curl command](https://github.com/mitmproxy/mitmproxy/issues/2649#issuecomment-392342343).
- `b` save contents of focused request/response to a file

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

## Troubleshooting

> Client TLS handshake failed. The client does not trust the proxy's certificate for ...

Cert isn't trusted by the client. If using a JVM app make sure the CA cert has been installed into the JVM keystore. For DBeaver see [here](https://dbeaver.com/docs/dbeaver/Importing-CA-certificates-from-your-local-Java-into-DBeaver/).

Restart the application after adding the CA cert.

> Flows stop showing

The client might disconnect due to inactivity, and then continue without the proxy. Check the events to detect a disconnect.

Restart the client.

## System cert

See Keychain Access - System - Certificates.

Show the cert

```
security find-certificate -c mitmproxy
```

Remove user's trust of the cert (it will remain in keychain)

```
security remove-trusted-cert -d ~/.mitmproxy/mitmproxy-ca-cert.pem
```

Delete the cert

```
sudo security delete-certificate -c mitmproxy
```

If you delete the cert without removing trust, it will still be trusted and `security verify-cert -c ~/.mitmproxy/mitmproxy-ca-cert.pem` will succeed. To remove and untrust at the same time:

```
sudo security delete-certificate -t -c mitmproxy
```
