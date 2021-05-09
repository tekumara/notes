# coursier

Resolve using custom repo

```
coursier resolve org.apache.spark:spark-repl_2.11:2.3.2.3.1.0.6-1 -r https://repo.hortonworks.com/content/repositories/releases
```

Resolve using local repo

```
coursier resolve org.apache.spark:spark-repl_2.11:2.3.2.3.1.0.6-1 -r file:/usr/repo/
```

Show tree of dependencies

```
coursier resolve org.apache.spark:spark-repl_2.11:2.3.2.3.1.0.6-1 -t
```

Fetch artifact

```
coursier fetch com.amazonaws:aws-java-sdk-bundle:1.11.271:jar
```

Coursier stores artifacts in _~/Library/Caches/Coursier_

## Issues

[Exclusions under \<dependencies\> not applied transitively](https://github.com/coursier/coursier/issues/2034)
