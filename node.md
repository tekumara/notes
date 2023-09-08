# Node

## Install binaries via script

Install Node LTS binaries into _/usr/local_:

```
curl -sfLS install-node.vercel.app/lts | bash -s -- --yes
```

See [vercel/install-node](https://github.com/vercel/install-node/blob/master/install.sh) for more details.

## Install via Debian/Ubuntu packages

Prefer the scripted install above because it's a nice one-liner.

But if you want to install the node debian packages from [nodesource/distributions](https://github.com/nodesource/distributions):

```
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/nodesource.gpg

NODE_MAJOR=18 # Current LTS
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

apt-get update
apt-get install -y nodejs
```

NB: will install python2.7 if not present.

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
