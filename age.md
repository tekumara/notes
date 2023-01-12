# age

Encrypts using

- [native X25519 keys](https://github.com/FiloSottile/age/blob/v1.1.1/doc/age.1.ronn?plain=1#L151)
- [ssh keys](https://github.com/FiloSottile/age/blob/v1.1.1/doc/age.1.ronn?plain=1#L169) - both rsa and ed25519
- [passphrase](https://github.com/FiloSottile/age/blob/v1.1.1/doc/age.1.ronn?plain=1#L16)

Keys are asymmetric (public/private). The passphrase uses symmetric encryption.

Age encrypted files are binary. To encode them as ASCII, use the PEM encoded format (aka armor) via the `-a` option.

There is no default path for age keys and [age doesn't have a global keyring](https://github.com/FiloSottile/age/blob/v1.1.1/age.go#L16). Age keys are cheap, small blocks of text which can be managed manually or by an application.

## Generate key

Generate a key and convert it to qrcode png image

```
age-keygen | qrencode --size 10 -o - | imgcat
```

## Encrypt / decrypt

Encrypt to all the recipients listed in _~/.passage/recipients_

```
echo foobar | age -R ~/.passage/recipients > foobar.age
```

Decrypt

```
age -d foobar.age -i key.age
```

Reencrypt

```
# identities used to encrypt the file
identities_file=~/.passage/identities
# new recipients
recipients_file=.age-recipients

# files to reencrypt
for agefile in {topsecret,websites/*}.age; do
    echo "$agefile"
    agefile_temp=$(mktemp /tmp/age.XXXXXX) && age -d -i "$identities_file" "$agefile" | age -e -R "$recipients_file" -o "$agefile_temp" && mv "$agefile_temp" "$agefile" || rm -f "$agefile_temp"
done
```

## Passphrase encryption

scrypt is used to [derive the key](https://github.com/str4d/rage/issues/338#issuecomment-1242751049) from the passphrase. It has a workfactor that targets [~1 second](https://github.com/FiloSottile/age/blob/v1.1.1/scrypt.go#L45) to derive a key on a modern machine.

To encrypt using a passphrase (ie: without a key):

```
echo 'secret' | age -p -o encrypted-secret.txt
```

### Passphrase protect a key

To generate and encrypt a key (aka identity) with a passphrase:

```
age-keygen | age -p > key.age
```

Or as a QR code (uses the ascii armor for decoding as text on iphone):

```
age-keygen | age -p -a | qrencode --size 10 -o - > /tmp/key.png
```

Decode using QR code key (with passphrase):

```
age -d -i <(zbarimg -q --raw /tmp/key.png) encrypted.file.age
```
