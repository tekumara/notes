# Maven usage

## mvn commands

`mvn help:effective-pom`  
`mvn install -DskipTests=true`

## List dependencies

- `mvn dependency:tree`
- `mvn dependency:list`

Show dependency tree for just the `core` project (module)

```
mvn dependency:tree -pl core

# or alternatively
cd core && mvn dependency:tree
```

Show dependency tree for profile `hadoop-3.2`

```
mvn dependency:tree -Phadoop-3.2
```

NB:

- When mvn dependency:tree errors use mvn dependency:list
- mvn dependency:tree is not correct in Maven 3 - see [this](https://cwiki.apache.org/MAVEN/maven-3x-compatibility-notes.html#Maven3.xCompatibilityNotes-DependencyResolution)

=> prefer mvn dependency:list

[maven-dependency-plugin](https://maven.apache.org/plugins/maven-dependency-plugin/index.html)
