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
