# cosign

[Install](https://docs.sigstore.dev/cosign/installation/):

- macos : `brew install cosign'
- ubuntu:

  ```
  version=1.7.1 && wget "https://github.com/sigstore/cosign/releases/download/v${version}/cosign-linux-amd64"
  sudo mv cosign-linux-amd64 /usr/local/bin/cosign
  sudo chmod +x /usr/local/bin/cosign
  ```

Generate key pair, cosign.key and cosign.pub, in the current directory:

```
cosign generate-key-pair
```

Starting with an alpine repo:

```
crane ls localhost:5555/alpine
latest
```

Sign and store sig in registry:

```
cosign sign --key cosign.key localhost:5555/alpine:latest
```

Signature now exists in the repo:

```
crane ls localhost:5555/alpine
latest
sha256-a777c9c66ba177ccfea23f2a216ff6721e78a662cd17019488c417135299cd89.sig
```

Verify:

```
cosign verify --key cosign.pub localhost:5555/alpine
```

Sign blob (a markdown file)

```
cosign sign-blob --key cosign.key README.md > README.sig
```

Verify blob (a markdown file)

```
cosign verify-blob --key cosign.pub --signature README.sig README.md
```

Upload blob

```
cosign upload blob -f README.md localhost:5555/readme
```

Sign and upload blob

```
cosign sign --key cosign.key --payload README.md localhost:5555/readme-signed
```

Download blob using [sget](https://github.com/sigstore/cosign#sget):

```
sget localhost:5555/readme -key cosign.pub > readme
sget localhost:5555/readme@sha256:0c5834c5243e64acc398983b01bc6272f6fe2f2c2320c425edf00ed9fd8e489c > readme
```

## KMS

Extract AWS KMS public key from private key:

```
cosign public-key --key awskms:///$arn
```

Actions required:

- public-key/sign/verify: `kms:GetPublicKey`, `kms:DescribeKey`
- sign:`kms:Sign`
- verify: `kms:Verify` only when using remote verification

For more info see [KMS - AWS](https://github.com/sigstore/cosign/blob/main/KMS.md#aws)
