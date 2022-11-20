# bash opts

## zsh

```shell
zparseopts -E -D -- \
        -host:=host \
        -user:=user \
        -keyfile:=key_file \
        -clean=clean

echo "host=$host[2]"
echo "user=$user[2]"
echo "keyfile=$keyfile[2]"
echo "clean=$clean"
```
