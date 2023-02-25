# docker-diff

Install [container-diff](https://github.com/GoogleContainerTools/container-diff) on linux:

```
curl -LO https://storage.googleapis.com/container-diff/latest/container-diff-linux-amd64 && \
sudo install container-diff-linux-amd64 /usr/local/bin/container-diff
```

To compare python packages diff in two local images:

```
container-diff diff daemon://repo1:tag1 daemon://repo1:tag2 --type=pip
```

To compare history diff:

```
container-diff diff daemon://repo1:tag1 daemon://repo1:tag2 --type=history
```
