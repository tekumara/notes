# Maven usage

## mvn commands

`mvn help:effective-pom`  
`mvn install -DskipTests=true`  

## List dependencies

- `mvn dependency:tree`
- `mvn dependency:list`

NB:

- When mvn dependency:tree errors use mvn dependency:list
- mvn dependency:tree is not correct in Maven 3 - see [this](https://cwiki.apache.org/MAVEN/maven-3x-compatibility-notes.html#Maven3.xCompatibilityNotes-DependencyResolution)

=> prefer mvn dependency:list

[maven-dependency-plugin](https://maven.apache.org/plugins/maven-dependency-plugin/index.html)
