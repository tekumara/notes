# cog

Start local docker registry:

```
docker run -d -p 5000:5000 --name registry registry:2
```

Start cog server:

```
cog server --port=8080 --docker-registry=localhost:5000
```

Clone cog-examples (requires git-lfs):

```
git clone git@github.com:replicate/cog-examples.git
```

Build:

```
cd cog-examples/hello-world
cog repo set localhost:8080/examples/hello-world
cog build
```
