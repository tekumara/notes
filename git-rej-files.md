# git .rej files

Apply changes in _file.rej_ to _file_ that `patch` could not apply:

```
wiggle --replace file file.rej
```

Apply all rej files

```
for rej in *.rej .*.rej; do
    base="$(basename -s .rej "$rej")"
    echo "Applying $rej to $base"
    wiggle --replace "$base" "$rej"
    rm "$rej"
    rm "$base.porig"
done
```

NB: `--no-backup` doesn't work see [#25](https://github.com/neilbrown/wiggle/issues/25)
