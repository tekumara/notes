# keychain

Set the timeout on the aws-vault keychain to 9 hours

```
security set-keychain-setting -t 32400 $HOME/Library/Keychains/aws-vault.keychain-db
```

To fetch the aws-vault oidc token

```
security find-generic-password -D "aws-vault oidc token" -w
```

Create a new keychain

```
security create-keychain  $HOME/Library/Keychains/delme.keychain-db
```

List the keychain search list

```
security list-keychains
```
