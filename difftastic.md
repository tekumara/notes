# difftastic

[difftastic](https://github.com/wilfred/difftastic) is a structural diff that understands syntax.

By default displays differences side by side, which is nice.

Loses some efficacy when too many parse errors exist in the file (eg: due to conflicts).

## git

On the command line:

```
git -c diff.external=difft diff
```

## jj

On the command line:

```
jj diff --tool difft
```

[Config jj](https://difftastic.wilfred.me.uk/jj.html):

```
[ui]
diff-formatter = ["difft", "--color=always", "$left", "$right"]
```
