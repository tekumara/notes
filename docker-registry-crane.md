# docker registry (crane)

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

Export by digest (ie: checksum) to a local file:

```
crane export localhost:5555/readme@sha256:0c5834c5243e64acc398983b01bc6272f6fe2f2c2320c425edf00ed9fd8e489c > readme
```

Extract the config digest (aka docker image id):

```
crane manifest nvidia/cuda:11.2.1-runtime-ubuntu20.04 --platform linux/amd64 | jq -r .config.digest
```

Fetch the config blob (which is an [image spec](https://github.com/moby/moby/tree/master/image/spec)) doc) then extract commands for non-empty layers from the history:

```
crane config nvidia/cuda:11.2.1-runtime-ubuntu20.04  --platform linux/amd64 | jq -r '.history[] | select(.empty_layer != true) | .created_by'
```

You can also fetch the config blob via its digest, eg:

```
crane blob nvidia/cuda:11.2.1-runtime-ubuntu20.04@sha256:3963e0f7ab539b9be67648cb7ffbabb1d6676e045971eb25347e7c16b3a689e7
```

Get compressed size of image on remote repository in MiB (the [same as compressed size on Dockerhub](https://hub.docker.com/layers/library/python/3.9.13-buster/images/sha256-e21225e5c86f11108123d2ca43bdb66c1a1b0991272232d185beca089b64791d?context=explore)):

```
crane manifest python:3.9.13-buster --platform linux/amd64 | jq '[.layers[].size] | add' | awk '{printf "%''d MiB\n", $1/1048576}'
```

Get manifest (or manifest list) digest (ie: checksum) for a tag (or latest if no tag):

```
❯ crane digest python:3.9-slim
sha256:3bab254e90bb0986ead59a3d415e719439e629d0ff3acfdfc96021a75aab0621
```

NB: This is the same as the `Docker-Content-Digest` and `X-Checksum-Sha256` headers when fetching the manifest via `crane digest -v`.

## curl

[List repos](https://distribution.github.io/distribution/spec/api/#listing-repositories):

```
curl localhost:5555/v2/_catalog
```

[List tags](https://distribution.github.io/distribution/spec/api/#listing-image-tags) for a repo:

```
curl localhost:5555/v2/my-ubuntu/tags/list
```

## Auth

[DockerHub auth](https://docs.docker.com/registry/#authentication), adapted from this [gist](https://gist.github.com/Exchizz/02b2276cb992c5c7cd04a824c921d0f3)):

```
REPO=tekumara/spark
TOKEN="$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${REPO}:pull" | jq -r '.token')"
curl -H "Authorization: Bearer $TOKEN" https://registry-1.docker.io/v2/$REPO/tags/list
```

With Artifactory, use https and basic auth, eg:

```
curl -u "$ARTIFACTORY_USER:$ARTIFACTORY_PASS" -L https://$REGISTRY/v2/$REPO/tags/list
```

Can also use the [auth endpoint to get creds](https://jfrog.com/help/r/jfrog-artifactory-documentation/set-your-docker-credentials-manually).

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

## Docker

Get manifest (same as crane manifest):

```
docker manifest inspect
```

Can be used to verify if image exists.
