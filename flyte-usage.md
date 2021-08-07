# flyte usage

Configure cli

```
export FLYTECTL_CONFIG=$HOME/.flyte/config-sandbox.yaml
```

Build image in sandbox (assumes sandbox has mounted a source dir)

```
flytectl sandbox exec -- docker build . --tag myapp:v1
```

Package (serialise to protobuf)

```
pyflyte --pkgs myapp.workflows package --image myapp:v1
```

Register

```
flytectl register files --project flytesnacks --domain development --archive flyte-package.tgz --version v1
```
