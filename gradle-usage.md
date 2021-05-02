# Gradle usage

## Dependency graph

```
./gradlew dependencies
```

For a particular configuration
```
./gradlew dependencies --configuration runtimeOnly
```


## Daemon

To see running daemons (for the current version)

```
./gradlew --status
```

## Logs

To see info level logs `gradle --info`

## To see which tasks will be run

```
./gradlew <task> --dry-run
```

To see the task dependency tree, install https://github.com/dorongold/gradle-task-tree: 
```
plugins {
    id "com.dorongold.task-tree" version "1.4"
}
```

And then: `./gradlew compile taskTree`

## Run tasks against subproject only

`gradle -p common test`

Sets the project dir to `common`, and the executes task `test`

## gradle/wrapper folder

Should be added to source control ([ref](http://stackoverflow.com/questions/20348451/why-gradle-wrapper-should-be-commited-to-vcs))

## publish local

In the dependency:
```
./gradlew publishToMavenLocal
```
Then add the following to the dependent consumer:
```
repositories {
        mavenLocal()
}
```

## task to run a main class

```
task myApp(type: JavaExec) {
    classpath = sourceSets.main.runtimeClasspath
    main = 'me.MyApp'
    if (System.getProperty('exec.args') != null) {
        args(System.getProperty('exec.args').split())
    }
    //if you need you app to read stdin
    standardInput = System.in
    jvmArgs = ['-Xms8G', '-Xmx8G']
}
```

eg: `./gradlew -Dexec.args="foo" myApp`


## Mute all gradle output
```
./gradlew --console plain --quiet
```

## Application packaging

build.gradle:

```
apply plugin: 'application'
mainClassName = 'myapp.Main'
```

To build: `./gradlew installApp`

Will create 
```
build/install/myapp
  bin
    myapp
    myapp.bat
  lib
    myapp-1.0.jar
    jackson-annotations-2.5.0.jar
    jackson-core-2.5.1.jar
    ...other dependencies
```

To run: `build/install/myapp/bin/myapp`