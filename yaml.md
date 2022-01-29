# yaml

Convert json to yaml using [yq](https://github.com/mikefarah/yq):

```
yq e . -P file.json
```

Convert yaml to json:

```
yq e . -P -o json file.yaml
```
