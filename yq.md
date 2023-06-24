# yq

## Install

Linux: `sudo snap install yq`

## Usage

Convert json to yaml (nb: doesn't support ndjson):

```
yq . -P file.json
```

Convert yaml to json:

```
yq . -o json file.yaml
```

Convert toml to json:

```
yq . -o json -p toml Cargo.lock
```

No support for [string interpolation yet](https://github.com/mikefarah/yq/issues/1149).
