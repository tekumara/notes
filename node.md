# Node

## Install on Debian/Ubuntu

Install Node.js LTS (v12.x) from the [nodesource/distributions](https://github.com/nodesource/distributions):

```
# Using Ubuntu
curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Using Debian, as root
curl -sL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

# Using Amazon Linux
curl -sL https://rpm.nodesource.com/setup_lts.x | sudo bash -
sudo yum install -y nodejs
```

NB: will install python2.7 if not present.

## Scripted install of binaries

Prefer using a package manger (see above) unless you are building a minimal Docker image.

Install latest Node LTS into _/usr/local_:

```
curl -sL install-node.now.sh/lts | bash -s -- --yes
```

See [vercel/install-node](https://github.com/vercel/install-node/blob/master/install.sh) for more details.

## npm

Find latest version of _pyright_:

```
npm search pyright
```

To install pyright into _./node_modules/_:

```
npm pyright
```

To install pyright into _$NODE_PATH$_:

```
npm -g pyright
```

## node prefix

`node -p process.config.variables.node_prefix` will show the prefix baked into node, eg: /usr/, in which case node will look for global modules in /usr/node_modules.

This may be [different from the npm](https://github.com/nodejs/node/issues/18024#issuecomment-355848073) (see `npm config get prefix`).

You can override the global node_modules location using, eg: `NODE_PATH=/usr/local/lib/node_modules`
