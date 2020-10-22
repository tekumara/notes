# Node on Linux

Install the latest version via [nvm](https://github.com/nvm-sh/nvm):

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash

# activate without restarting the shell
. ~/.nvm/nvm.sh

nvm install node

# test
node --version
```

## npm

Find latest version of *pyright*:

```
npm search pyright
```

To install pyright into *./node_modules/*:

```
npm pyright
```

To install pyright into *$NODE_PATH$*:

```
npm -g pyright
```
