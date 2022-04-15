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

Inspect digest for a tag (or latest if no tag):

```
crane digest localhost:5555/readme
```

Export by digest to a local file:

```
crane export localhost:5555/readme@sha256:0c5834c5243e64acc398983b01bc6272f6fe2f2c2320c425edf00ed9fd8e489c > readme
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
