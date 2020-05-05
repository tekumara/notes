# Jupyter usage

## Shell

To execute a single line shell command and capture output to a variable:
```
ls = !ls -al
```

To execute a multiple line shell command and capture output to a variable:
```
%%bash --out std_out
ssh ....
```

To use variables in a single line shell reference with `{<variable>}`
ref: https://stackoverflow.com/questions/19579546/can-i-access-python-variables-within-a-bash-or-script-ipython-notebook-c

## Magics

[Magics](https://ipython.readthedocs.io/en/stable/interactive/magics.html) are prefixed with `%`.

To run pip with the current kernel: `%pip`

## Visualisations

Run the following first: 
```
%matplotlib inline
```


## Reconnecting

If you close the browser the Jupyter kernel will continue to run. You can reopen the notebook and reconnect to the kernel but you won't receive any output from the currently running cell (see [#641](https://github.com/jupyter/notebook/issues/641)). If the cell is still running you can interrupt the kernel to stop it. Output for subsequent executions will then be visible.

As an alternative, start ipython in a tmux session.