# bash pipelines

Connecting the input and output of several commands, and grouping commands. See [Bash Reference - Pipelines](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Pipelines)

## Logging

Log stdout and stderr to a file

`.... >/tmp/log 2>&1`
or
``.... &> /tmp/log`

`&>` requires a file argument, so you can't pipe directly after it. So to log stdout and stderr to console and a file use `2>&1` eg:

`2>&1 | tee /tmp/log`

## Running multiple commands

```
A; B = Run A and then B, regardless of success of A
A && B = Run B if A succeeded
A || B = Run B if A failed
A & = Run A in background.
```

([ref](http://askubuntu.com/a/539293/6127), [Bash Reference Manual - Lists of Commands](http://www.gnu.org/software/bash/manual/bashref.html#Lists))

## Run commands in subshell

Because cd is run in a subshell, it won't change directory in the current shell.

```
(cd bin && ./tomcat_ctl.sh stop)
```

Combine local and remote files into one

```
(cat ~/.zsh_history && ssh tui 'cat ~/.zsh_history' )> /tmp/merged
```

## Grouping commands

To run a list of commands in the current shell:

```
{ list ; }
```

The trailing semicolon isn't required if the closing curly bracket appears on its own line, or you are using zsh.

When commands are grouped, redirections may be applied to the entire command list. See [Bash Reference Manual - Grouping Commands](http://www.gnu.org/software/bash/manual/bashref.html#Command-Grouping)

## Passing output of a command to another program as if it were the file contents

Use `<(command)` to pass one command's output to another program as if it were the contents of a file. Bash pipes the program's output to a pipe and passes a file name like _/dev/fd/63_ to the outer command.

```
diff <(./a) <(./b)
```

```
bcompare <(unzip -l play.zip | sort) <(unzip -l play.old.zip | sort)
```

Similarly you can use `>(command)` if you want to pipe something into a command.

See:

- [Chapter 23. Process Substitution](https://tldp.org/LDP/abs/html/process-sub.html)
- [Stack Overflow](http://stackoverflow.com/a/3800207/149412)

## Redirections

`cmd <<< "string"` Redirect a single line of text to the stdin of cmd. This is called a here-string. [ref](http://www.catonmat.net/download/bash-redirections-cheat-sheet.pdf)

## Keep background process running after logging off

Background processes started from a script/shell (either using `&` or starting them with a daemon switch) will exit when the shell ends.
To avoid this, use nohup to prevent exit signals propagating to child processes of the shell.

eg:

```
nohup my-background-command &
```

NB: Under some weird edge cases (eg: calling nohup many layers down a call stack of multiple scripts) there can be timing issues that mean this doesn't work. Adding a sleep after the nohup will solve this.

tmux has the advantage that you can easily reconnect to the program's input terminal.
