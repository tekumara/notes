# openssl

## Algorithms

[RSA](<https://en.wikipedia.org/wiki/RSA_(cryptosystem)>) is a public-key algorithm.

## Standard formats

[PKCS8](https://en.wikipedia.org/wiki/PKCS_8) is a [structured format](https://en.wikipedia.org/wiki/PKCS) for storing keys irrespective of their algorithm. [PKCS1](https://en.wikipedia.org/wiki/PKCS_1) was the first version of the format and used for RSA keys specifically. openssl defaults to PKCS1 for RSA keys. For more info see [this explanation](https://stackoverflow.com/a/57260862/149412).

## Encodings

DER is a binary encoding. [PEM](https://cryptography.io/en/latest/faq/#why-can-t-i-import-my-pem-file) is a base64 string encoding of DER with a header, footer, and optional metadata. See this [stackoverflow question](https://stackoverflow.com/questions/48958304/pkcs1-and-pkcs8-format-for-rsa-private-key) for more info on the differences.

## Examples

PKCS8 PEM:

```
-----BEGIN PRIVATE KEY-----
...
-----END PRIVATE KEY-----
```

PKCS1 (aka RSA) PEM:

```
-----BEGIN RSA PRIVATE KEY-----
...
-----END RSA PRIVATE KEY-----
```

## Usage

Encrypt an existing private key with a passpharse using AES256 for encryption:

```
openssl rsa -aes256 -in your.key -out your.encrypted.key
```

## Python Usage

Read a PEM encoded key using the `cryptography` Python package (which uses openssl as a backend):

```python
from cryptography.hazmat.primitives import serialization

private_key_path = "/tmp/private_key.txt"

with open(private_key_path, 'rb') as key:
    # equivalent to openssl pkey -inform pem -text -noout -in $private_key_path
    # see https://www.openssl.org/docs/man3.0/man1/openssl-pkcs8.html
    p_key = serialization.load_pem_private_key(
        key.read(),
        password=None)
```
