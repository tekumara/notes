# nodeenv

## Install prebuilt version

To download and install the latest prebuilt version of node into the current python virtualenv (takes 3 mins):

```
nodeenv -p
```

This creates:

- *$VIRTUAL_ENV/include/node/*
- *$VIRTUAL_ENV/include/src/node_** NB: this can be removed by using `nodeenv -c` which will save ~100MB
- *node* and *npm* binaries in *$VIRTUAL_ENV/bin/*
- *$VIRTUAL_ENV/lib/node_modules* containing npm

The virtualenv *activate* script is modified to set `NODE_PATH`. Doesn't take immediate effect, so needs to be run after install.

## Use system version

To link the globally installed system version of node into the current python virtualenv (recommended, much faster than the above):

```
nodeenv -p -n system
````

This creates a *$VIRTUAL_ENV/bin/node* shell script which calls the system `node` binary. There isn't an npm script. The virtualenv *activate* script is modified to set `NODE_PATH`. Doesn't take immediate effect, so needs to be run after linking.

To create a node env and install packages globally (ie: equivalent to `npm -g`):

```
nodeenv -p -n system -r requirements.node.dev.txt
```
