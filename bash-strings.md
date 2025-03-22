# bash strings

## newlines

Embedding actual new line, rather than \n in string:

```bash
STR=$'Hello\nWorld' # must be single quote here

# or

STR="Hello
World"
```

Rending the variable with the new line:

```bash
# new line rendered as space 
echo $STR
Hello World

# double quote will render newline
echo "$STR"
Hello
World
```

NB: zsh will render with the newline, not the space, when unquoted.
