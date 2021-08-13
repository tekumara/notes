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

Create execution spec from launchplan

```
flytectl get launchplan -p flytesnacks -d development pima_diabetes.diabetes.diabetes_xgboost_model --execFile exec.yaml
```

Execute:

```
flytectl create execution --project flytesnacks --domain development --execFile exec.yaml
```

Monitor execution:

```
flytectl get execution --project flytesnacks --domain development $execution_name
```

## Troubleshooting

### task with different structure already exists

Existing tasks cannot be deleted. So instead, register the task with a new version. Version strings are arbitrary.
