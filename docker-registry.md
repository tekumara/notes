# docker registry

List tags for a repo using [skopeo](https://github.com/containers/skopeo)

```
skopeo list-tags docker://docker.io/tekumara/spark
```

or via curl using the [Docker Registry API](https://docs.docker.com/registry/spec/api/#listing-image-tags) (adapted from this [gist](https://gist.github.com/Exchizz/02b2276cb992c5c7cd04a824c921d0f3)):

```
REPO=tekumara/spark
TOKEN="$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${REPO}:pull" | jq -r '.token')"
curl -H "Authorization: Bearer $TOKEN" https://registry-1.docker.io/v2/$REPO/tags/list
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

[List repos](https://docs.docker.com/registry/spec/api/#listing-repositories):

```
curl localhost:5555/v2/_catalog
```

or using [crane](https://github.com/google/go-containerregistry/tree/main/cmd/crane):

```
crane catalog localhost:5555
```

List tags for a repo

```
curl localhost:5555/v2/my-ubuntu/tags/list
```

List tags using skopeo

```
skopeo list-tags --tls-verify=false docker://localhost:5000/my-ubuntu
```

## Remote tag image

To tag an image already on the registry using [crane](https://github.com/google/go-containerregistry/tree/main/cmd/crane):

```
crane tag prefecthq/prefect:1.2.0-python3.9
```

See also [joshdk/docker-retag](https://github.com/joshdk/docker-retag)
