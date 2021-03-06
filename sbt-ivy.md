# Sbt & Ivy

## Examining dependency tree

Start sbt and navigate to project, eg:

```
sbt
project X
```

To resolve dependencies, including downloading missing dependencies:

```
update
```

To view detailed debug data from the update, and generate an ivy report:

```
last update
```

Ivy reports will be generated in `/target/scala-2.12/resolution-cache/reports/PROJECTNAME/`. Open `compile-resolved.xml` in firefox (chrome won't work).

Ref: [Sbt docs - Dependency Management Flow](http://www.scala-sbt.org/0.12.1/docs/Detailed-Topics/Dependency-Management-Flow.html)

## Troubleshooting

### configuration not found in commons-logging#commons-logging;1.1.1: 'master(compile)'. Missing configuration: 'compile'

Quick workaround

```
mv ~/.ivy2/cache/commons-logging /tmp
```

Then re-run sbt.

This happens because when using deps that don't have a complete pom.xml/ivy.xml, so ivy will create a minimal one, eg: if using dependencies supplied locally which didn't have a full pom.xml/ivy.xml, update them with one, or use a repo like Maven Central that does. Also, make sure your maven repos have the correct usepom config, as per [here](http://lightguard-jp.blogspot.com.au/2009/04/ivy-configurations-when-pulling-from.html)

To prevent the play framework from generating minimal ivy files for files that it contains in its lib dir (eg: play-1.2.3/framework/lib) you need to modify play-1.2.3/framework/dependencies.yml.

This is the section which fetches from the lib dir, and creates a minimal ivy.xml:

```
    - playCoreDependencies:
        type:       local
        artifact:   "${play.path}/framework/lib/[artifact]-[revision].jar"
        contains:   *allDependencies
```

Add the following section, after the above section like the following, for deps you want to fetch from maven central with a complete ivy.xml:

```
    - mavenCentral:
        type:   iBiblio
        contains:
            - commons-beanutils 1.8.3
            - commons-io 2.0.1
            - commons-logging 1.1.1
            - dom4j 1.6.1
            - org.bouncycastle -> bcprov-jdk15 1.45
            - commons-lang 2.6
            - org.slf4j -> slf4j-api 1.6.1
            - commons-codec 1.4
```

### (update) java.lang.IllegalArgumentException: org.tukaani#xz;1.0!xz.jar origin location must be absolute: file:/Users/tekumara/.m2/repository/org/tukaani/xz/1.0/xz-1.0.jar

Clear the ivy cache, eg: `rm ~/.ivy2/cache/org.tukaani/xz/*1.0*`

### commons-io#commons-io;2.6: org.apache.commons#commons-parent;42!commons-parent.pom(pom.original) origin location must be absolute: file:/Users/tekumara/.m2/repository/org/apache/commons/commons-parent/42/commons-parent-42.pom

Clear the ivy cache, eg: `rm -rf ~/.ivy2/cache/org.apache.commons/commons-parent`
