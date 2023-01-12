# age-plugin-yubikey

Generate age identity:

```
age-plugin-yubikey
```

List yubikeys:

```
ykman list
```

Create an identity file from slot 1 on key with serial 12345678:

```
age-plugin-yubikey -i --serial 12345678 --slot 1 > age-yubikey-identity-abcd1234.txt
```

List the recipient (ie: public key) in slot one:

```
age-plugin-yubikey -l --serial 12345678 --slot 1
```

List the cert data stored in the slot

```
ykman --device 12345678 piv info
```

Encrypt a file to a recipient identity:

```
cat foo.txt | age -r age1yubikey1qd08rrs3ypluwf0altuykhlnzcpy87pl8vwar2ad89zw48qe59qf5rezzgs -o foo.txt.age
```

Decrypt a file with this identity:

```
cat foo.txt.age | age -d -i age-yubikey-identity-abcd1234.txt > foo.txt
```
