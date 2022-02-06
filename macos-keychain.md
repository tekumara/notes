# keychain

Set the timeout on the aws-vault keychain to 9 hours

```
security set-keychain-setting -t 32400 $HOME/Library/Keychains/aws-vault.keychain-db
```

To fetch the aws-vault oidc token

```
security find-generic-password -D "aws-vault oidc token" -w
```

To see details of all items in the aws-vault keychain

```
security find-generic-password -s aws-vault
```

Show the password stored for github.com

```
security find-internet-password -s github.com -w
```

Create a new keychain

```
security create-keychain  $HOME/Library/Keychains/delme.keychain-db
```

List the keychain search list

```
security list-keychains
```

Delete the item of kind "aws-vault session"

```
security delete-generic-password -D "aws-vault session"
```

## Using a keychain

A keychain can be used once unlocked. If a keychain is locked you'll be prompted for the password to unlock it, eg:

```
aws-vault wants to use the "aws-vault" keychain
```

NB: the `login` keychain is unlocked when you login.

When an keychain is unlocked and an application wants to use an item in the keychain you'll be prompted, eg:

```
aws-vault wants to use your confidential information stored in "aws-vault (default)" in your keychain.
```

You can select "Always allow" to no longer be prompted when this application requests this item. Do not ever allow all applications to access an item.

"Always allow access" can also be configured from Keychain Access - Select item - Get Info - Access Control.

Or, via the command line. eg: to always allow aws-vault access to the default item in the aws-vault keychain:

```
security add-generic-password -s aws-vault -a default -U -T $(which aws-vault)
```

NB: this requires the login password and doesn't work!?
