# postgres

## usage

`\list` or `\l` list databases

## vs sql server

postgres doesn't support clustered indexes so not so good for multi-tenancy because customers data cannot be kept together for performant IO.

## docker

```
docker run --rm -e POSTGRES_PASSWORD=password -d --name pg postgres
docker exec -it pg psql -h localhost -U postgres
docker stop pg
```
