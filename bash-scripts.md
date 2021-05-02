# bash scripts

## heredoc

A Here document (Heredoc) is a redirection that allows you to pass multiple lines of input to a command.

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

<<- ignores leading tabs.

To read into a variable:

```
read -r -d '' VAR << EOM
This is line 1.
This is line 2.
Line 3.
EOM
```

https://en.wikipedia.org/wiki/Here_document#Unix_shells
https://stackoverflow.com/a/2500451/149412

## detect interactive shell

```
[[ $- == *i* ]] && echo "in an interactive shell"
```
