# docker volumes

List contents of a volume

```
docker run --rm -i -v=dt-slim-api_terraform:/vol busybox find /vol
```

Delete a volume

```
docker volume rm $volume
```

List image id and its overlay dirs:

```
docker inspect -f $'{{.Id}}\t{{.GraphDriver.Data.LowerDir}}' $(docker images -aq)
docker inspect $(docker images -aq) |  jq -r 'map([.Id, .RepoTags, .GraphDriver.Data]) | .[] | "\(.[0])\t\(.[1])\t\(.[2])"'
```

List containers by name and their overlay dirs:

```
docker inspect -f $'{{.Name}}\t{{.GraphDriver.Data}}' $(docker ps -aq)
docker inspect $(docker ps -aq) |  jq -r 'map([.Name, .GraphDriver.Data]) | .[] | "\(.[0])\t\(.[1])"'
```
