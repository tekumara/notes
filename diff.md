# Diff

Side by side

```
diff -y -W $COLUMNS file1 file2
```

Side by side ignoring whitespace and showing only changed lines

```
diff -y -W  $COLUMNS -w --suppress-common-lines file1 file2
```

Try harder

```
diff -d
```

## Diff and patch

Create diff file

```
diff -uN build.xml "build mod.xml" > unified.diff
```

Apply patch

```
patch build.xml < unified.diff
```

## Colordiff

Install:

- Ubuntu: `sudo apt-get install colordiff`
- Mac: `brew install colordiff`

Replace `diff` commands with `colordiff`.

[Cool ways to Diff two HTTP Requests in your terminal!](https://gist.github.com/Nijikokun/d6606c036d89d3b1574c)

## Binary diff

```
colordiff -y <(xxd file1) <(xxd file2)
```

## Diff within a line/character level diff

`vim -d file1 file2` or `vimdiff file1 file2`

Or horizontal

`vim -d -o file1 file2` or `vimdiff -o file1 file2`

## Word diff

With colour:

```
wdiff -w "$(tput bold;tput setaf 1)" -x "$(tput sgr0)" -y "$(tput bold;tput setaf 2)" -z "$(tput sgr0)" file1 file2
```

[ref](http://unix.stackexchange.com/a/11144/2680)

## Diff output of two commands

Use [process substitution](http://tldp.org/LDP/abs/html/process-sub.html)

```
diff <(grep 24473 base/similar-headings.cosim | sort) <(grep 24473 stopword/similar-headings.cosim | sort)
```

## CSV diff

This uses comma as a word separator in the diff:

```
git diff --color-words --word-diff-regex="[^[:space:],]+" x.csv y.csv
```
