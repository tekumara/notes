# theia

Using the docker container with python plugins:

```
docker run -it --init -p 3000:3000 -v "$(pwd):/home/project:cached" theiaide/theia-python:latest
```

Run the latest master version:

```
git@github.com:eclipse-theia/theia.git
yarn start:browser
```

The above works with node v12.18.3, npm 6.14.6, yarn 1.22.10

## References

[https://github.com/eclipse-theia/theia](https://github.com/eclipse-theia/theia)
[theia python docker image](https://github.com/theia-ide/theia-apps/blob/master/theia-python-docker/latest.package.json)
