# docker registry

## crane

Install [crane](https://github.com/google/go-containerregistry/tree/main/cmd/crane):

```
brew install crane
```

List repos:

```
crane catalog localhost:5555
```

List tags for a repo

```
crane ls tekumara/spark
```

Copy an image from one repo to another (doesn't create a local image):

```
crane copy tekumara/spark:3.2.1-hadoop3.2-java11-python3.9-bullseye localhost:5555/tekumara/spark:3.2.1-hadoop3.2-java11-python3.9-bullseye
```

Tag an already pushed image:

```
crane tag localhost:5555/tekumara/spark:3.2.1-hadoop3.2-java11-python3.9-bullseye latest
```

Get repo digest (ie: the sha256 of the image) for a tag (or latest if no tag):

```
❯ crane digest python:3.9-slim
sha256:9ef969a374118f28a61261e2b018a7f9debcc0dc1342481bd8b8693c1457f46d
```

Export by digest to a local file:

```
crane export localhost:5555/readme@sha256:0c5834c5243e64acc398983b01bc6272f6fe2f2c2320c425edf00ed9fd8e489c > readme
```

Extract the config digest:

```
crane manifest nvidia/cuda:11.2.1-runtime-ubuntu20.04 --platform linux/amd64 | jq -r .config.digest                
```

Fetch the config blob, which is an [image spec](https://github.com/moby/moby/tree/master/image/spec)) doc, using its digest, then extract commands for non-empty layers from the history:

```
crane blob nvidia/cuda:11.2.1-runtime-ubuntu20.04@sha256:3963e0f7ab539b9be67648cb7ffbabb1d6676e045971eb25347e7c16b3a689e7 | jq -r '.history[] | select(.empty_layer != true) | .created_by'
```

Get compressed size of image on remote repository in MiB (the [same as compressed size on Dockerhub](https://hub.docker.com/layers/library/python/3.9.13-buster/images/sha256-e21225e5c86f11108123d2ca43bdb66c1a1b0991272232d185beca089b64791d?context=explore)):

```
crane manifest python:3.9.13-buster --platform linux/amd64 | jq '[.layers[].size] | add' | awk '{printf "%''d MiB\n", $1/1048576}'
```

## curl

[List repos](https://docs.docker.com/registry/spec/api/#listing-repositories):

```
curl localhost:5555/v2/_catalog
```

[List tags](https://docs.docker.com/registry/spec/api/#listing-image-tags) for a repo (adapted from this [gist](https://gist.github.com/Exchizz/02b2276cb992c5c7cd04a824c921d0f3)):

```
REPO=tekumara/spark
TOKEN="$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${REPO}:pull" | jq -r '.token')"
curl -H "Authorization: Bearer $TOKEN" https://registry-1.docker.io/v2/$REPO/tags/list
```

List tags for a repo (local registry):

```
curl localhost:5555/v2/my-ubuntu/tags/list
```

## Local registry

Run a [local registry](https://docs.docker.com/registry/deploying/):

```
docker run -d -p 5555:5000 --restart=always --name registry registry:2
```

Upload:

```
docker tag ubuntu:16.04 localhost:5555/my-ubuntu
docker push localhost:5555/my-ubuntu
```
