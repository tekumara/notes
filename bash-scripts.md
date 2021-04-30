# bash scripts

## heredoc

By default the contents of the heredoc are evaluated as if it were a double quoted string. To avoid evaluation, and treat special characters as literals, surround the here word with single quotes, eg:

```
cat <<'EOF'
               ((`\
            ___ \\ '--._
         .'`   `'    o  )
        /    \   '. __.'
       _|    /_  \ \_\_
jgs   {_\______\-'\__\_\
EOF
```

https://en.wikipedia.org/wiki/Here_document#Unix_shells
https://stackoverflow.com/a/2500451/149412

## detect interactive shell

```
[[ $- == *i* ]] && echo "in an interactive shell"
```
