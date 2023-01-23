# keychain

The default key chains are:

- `login` local to the device. Unlocked when you login. The password is your mac login password. Located at _~/Library/Keychains/login.keychain-db_.
- `Local Items` - Includes Safari passwords, credit cards, Wi-Fi (aka Airport network) passwords, and SSH key file paths and their passphrase (if any). [Implemented differently](https://apple.stackexchange.com/a/316220/224585) from traditional keychains, as an [encrypted sqlite database](https://github.com/n0fate/chainbreaker/issues/11#issuecomment-525326166). Not accessible from the `security` cli tool.
- `iCloud` - If iCloud syncing is enabled the `Local Items` keychain is renamed to `iCloud` and synced. To enable syncing on macOS/iPhone check `Settings > Apple ID > iCloud > Password & Keychain`

Set the timeout on the aws-vault keychain to 9 hours

```
security set-keychain-setting -t 32400 $HOME/Library/Keychains/aws-vault.keychain-db
```

To fetch the aws-vault oidc token

```
security find-generic-password -D "aws-vault oidc token" -w
```

To see details of all items for the aws-vault service (aka Where in the UI):

```
security find-generic-password -s aws-vault
```

Show the password stored for github.com

```
security find-internet-password -s github.com -w
```

Create a new keychain

```
security create-keychain $HOME/Library/Keychains/delme.keychain-db
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
