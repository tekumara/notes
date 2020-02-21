# Bazel

## Summary

I'd put Bazel in the "principled and worth studying but non-ergonomic hard to use" category...

Bazel's primary advantage seems to be for building massive code bases. If it takes you say > 20 mins to do a clean build then it can be a win because it does distributed/parallel build and caching right. I really like the way it does dependency management ie: resolve deps quickly and once up front, rather than seemingly randomly whenever Gradle feels like it, or SBT which takes forever and a day. The Skylark BUILD file language is restricted and not general purpose, which I think is nice because you end up with a declarative build file and a lot of the complexity hidden.

That said, it's a lot of work to set up (so many layers of indirection!) and unfortunately the out of the box scala rules don't use Zinc so the local test-compile feedback loop is like 2x longer :-( Java is probably OK.

In particular I found setting up external dependencies quite tricky, and there is a lack of support for repositories that require authentication. The external dependency story seems like it could do with a lot of love but I guess it hasn't received much attention because they vendor everything at the big G.

## What is bazel?

Bazel is a distributed build system, that manages an explicitly defined dependency graph of rules which are pure functions that turn inputs into outputs. Rules can even be bash scripts (see [genrule](https://docs.bazel.build/versions/master/be/general.html#genrule)). Rather than modification times like Make, bazel uses intelligent hashing of the compiler and inputs to detect when rebuilds need to occur. Outputs are stored and managed by the bazel cache using content addressable storage, and can be shared remotely.

Bazel makes it cheap to create fine grained modules, which coupled with pure functions, enable parallelization, caching, and remote execution which can scale your build to very large repos.  

Bazel build definitions are meant to be simple, with any complexity pushed into plugins, rather than providing a turing complete build language.

## Why bazel?

* Dependencies are resolved once when added, and not on every build - faster and means you can work offline.
* Dependencies are versioned once, across all projects, and move in lock-step
* Reproducible builds - you should never need to run `bazel clean` to get the build system out of an invalid state. Non-reproducibility is considered a bug, eg: [#3360](https://github.com/bazelbuild/bazel/issues/3360). If you want to trade away reproducibility, workers will allow you to run compilers that keep state.
* Warm starts and incremental module builds across machines - the Bazel remote build cache works across invocations and machines, so you get warms start on a new laptop without having to rebuild everything from a clean slate. Rules (including tests) are only invoked when there are changes.
* Speed - Bazel doesn't run your compile or test rules any faster than they would usually. In fact, without the use of an incremental compiler (which may cut against reproducibility) individual module builds will run slower. However, by breaking the build into small, pure functions that can be parallelized locally or on cloud machines (via remote execution) so the total build time can be reduced.
* Supports large code bases (eg: monorepos) - when the time to build a large code base from an empty/clean state is say >20 mins, bazel may be a win because parallelism enables faster builds and caching enables warm starts - see [this discussion](https://github.com/bazelbuild/rules_scala/issues/328#issuecomment-418572865)
* Explicit graph of build targets - can be queried to see what needs to be redeployed

Areas that are a little rough:

* Complex build system to set up
* No linking of scala source in IntelliJ - [#476](https://github.com/bazelbuild/intellij/pull/476)
* Using external dependencies from private Maven repos that require authentication requires workarounds eg: [#95](https://github.com/johnynek/bazel-deps/issues/95#issuecomment-436818518). [rules_jvm_external](https://github.com/bazelbuild/rules_jvm_external/) may help, although I haven't yet tried it.
* No Scala incremental compiler (Zinc) support out of the box - in part because Zinc doesn't guarantee reproducibility. However there is an implementation from [Databricks](https://databricks.com/blog/2019/02/27/speedy-scala-builds-with-bazel-at-databricks.html) and [higherkindness](https://github.com/higherkindness/rules_scala)
* Using S3 as a remote cache still not merged - [#4889](https://github.com/bazelbuild/bazel/pull/4889)

## Bazel vs alternatives

Pants trades off reproducible builds for faster builds in languages like Scala.

Gradle configures and resolves every time you build. Configuring takes 10s on a large multi-project build and resolving requires an internet connection.
Reruns tests when nothing has changed and using --build-cache`

Gradle also supports modularisation but gradle modules are typically quite heavyweight, and its build cache hasn't historically been reliable, although this is improving.

## Usage

`bazel info` to show version number, and embedded jdk version. Must be run in a bazel workspace.  
`bazel info execution_root` show the execution root, ie: the working directory where Bazel executes all actions during the execution phase.  
`bazel fetch //...` to prefetch all dependencies, normally happens as part of `bazel build` see [here](https://docs.bazel.build/versions/master/external.html#fetching-dependencies).  
`bazel build //...` build everything.  
`bazel test //...` test everything.  
`bazel cquery //...` show all targets.  
`bazel query 'rdeps(//..., //3rdparty/jvm/com/amazonaws:aws_java_sdk_dynamodb)'` show all targets depending on dynamodb.  
`bazel query "somepath(//myapp:tests, //3rdparty/jvm/org/scalatest:scalatest)"` show a path between two targets.  
`bazel query "allpaths(//myapp:tests, //3rdparty/jvm/org/scalatest:scalatest)"` show [all paths](https://docs.bazel.build/versions/master/query.html#path-operators) between two targets.  
`bazel query 'kind(rule, external:all)' --output label_kind` list all the rules in the `//external` package.  
`bazel query 'kind(maven_jar, //external:*)' --output build` list the definition of all the rules in the `//external` package of type maven_jar.  
`bazel query 'filter(.*log4j.*, kind(rule, external:all))' --output label_kind` list all log4j rules in the `//external package` NB: this is preferable to `bazel query 'kind(rule, external:all)' --output label_kind | grep log4j` as during the piping grep seems to miss some lines.  
`bazel shutdown` shut down the workspace's bazel processes.  

## External dependencies

"The WORKSPACE file in the workspace directory tells Bazel how to get other projects’ sources. These other projects can contain one or more BUILD files with their own targets. BUILD files within the main project can depend on these external targets by using their name from the WORKSPACE file." see [Working with external dependencies](https://docs.bazel.build/versions/master/external.html)

The [repository_rule](https://docs.bazel.build/versions/master/skylark/repository_rules.html) statement in `WORKSPACE` (or `.bzl` files loaded from `WORKSPACE`) sets up an external aka [remote repository](https://bazel.build/designs/2015/07/02/skylark-remote-repositories.html#remote-repository-rule). Each rule creates its own workspace with its own BUILD files and artifacts. Targets within a remote repo can be referenced by the remote repo name prefixed with `@`, eg:  `@remote_repo//proj:sometarget` or `@remote_repo` to refer to the target with the same name as the repo. Bazel recommends naming repos with underscores, eg: `com_google_guava` - for more details see [naming](https://github.com/bazelbuild/bazel/blob/4a74c5293050455e0ec0c965ea49eb3764cfe837/tools/build_defs/repo/java.bzl#L86).

Repository rules specify an [implementation function](https://docs.bazel.build/versions/master/skylark/repository_rules.html#implementation-function) which can fetch an artifact. The implementation function is only executed when needed during bazel build, fetch or query - see [when is the implementation function executed?](https://docs.bazel.build/versions/master/skylark/repository_rules.html#when-is-the-implementation-function-executed) and [RepositoryFunction.java](https://github.com/bazelbuild/bazel/blob/bf0df261fcc2995fa5a5b92392be747ec782a84c/src/main/java/com/google/devtools/build/lib/rules/repository/RepositoryFunction.java#L72). It will typically download/symlink artifacts into `$(bazel info output_base)/external/artifact_name/jar` ([ref](https://docs.bazel.build/versions/master/external.html#layout)). The `//external` package is virtual package that doesn't exist in your source tree, but contains rules that fetch artifacts. [This discussion](https://github.com/bazelbuild/bazel/issues/1952#issuecomment-266836372) suggests when referencing a repository target its better to use the repository name target (eg: `@org_slf4j_slf4j_log4j12//jar`) instead of the `//external` package target. External repositories themselves are not dependencies of a build ([ref](https://docs.bazel.build/versions/master/query.html#external-repos)). To list all rules defined in the external package: `bazel query 'kind(rule, external:all)' --output label_kind`

### Fetching external dependencies

The native `maven_jar` was java code was replaced by a more fully featured Skylark version (background [on why here](https://groups.google.com/d/msg/bazel-discuss/h0Lont-VPxo/hfIi5sQyBAAJ)). The downside is it requires maven to be installed, does not support source jars, and is not fast, see [benchmarks here](https://github.com/bazelbuild/bazel/issues/5452#issuecomment-399556806).

An example of using the Skylark `maven_jar`:

```
load('@bazel_tools//tools/build_defs/repo:maven_rules.bzl', 'maven_jar')
maven_jar(
    name = "my_org_secret_lib_2_11",
    artifact = "my.org:secret-lib_2.11:0.1.63",
    # sha1 is optional
    sha1 = "c9a0baa8bb91e8d7f4446510431fd466e539c062"
)
```

This shells out to `mvn` to run:

```
mvn org.apache.maven.plugins:maven-dependency-plugin:2.10:get -Dtransitive=false -Dartifact=my.org:secret-lib_2.11:0.1.63:jar
```

The above will use repositories and authentication specified in `~/.m2/settings.xml`. For more details see [maven_rules.bzl](https://github.com/bazelbuild/bazel/blob/4a74c5293050455e0ec0c965ea49eb3764cfe837/tools/build_defs/repo/maven_rules.bzl).

However, I recommend using the native [maven_jar](https://docs.bazel.build/versions/master/be/workspace.html#maven_jar) because it is fast, supports authentication, doesn't require maven installed externally and will download source jars. Here's an example using `maven_server` to access a repository requiring authentication:

```
maven_server(
  name = "the_cave",
  url = "https://myartifacts.xyz/artifactory/libs",
)

maven_jar(
  name = "some_treasure",
  artifact = "org.foo:some-treasure:3.1.0",
  sha1 = "e13484d9da178399d32d2d27ee21a77cfb4b7873",
  server = "the_cave",
)
```

This will use the following authentication settings, if specified, in `~/.m2/settings.xml`:

```
     <servers>
         <server>
             <id>the_cave</id>
             <username>alibaba</username>
             <password>openseasame</password>
         </server>
     </servers>
```

It fetches jar and source artifacts using [MavenDownloader.java](https://github.com/bazelbuild/bazel/blob/master/src/main/java/com/google/devtools/build/lib/bazel/repository/MavenDownloader.java#L125) with uses aether for resolution.

Neither Skylark nor native `maven_jar` fetches transitive dependencies. Instead use a tool like `bazel-deps` to do resolution of transitive dependencies and generate the appropriate bazel rules. There is some good discussion on not auto-magically fetching transitive dependencies on issue [#1410](https://github.com/bazelbuild/bazel/issues/1410#issuecomment-266828259).

The latest incarnation for fetching external deps is `jvm_maven_import_external` (via maven artifact coordinates) and `java_import_external` (via artifact urls). Their implementation is defined in [jvm.bzl](https://github.com/bazelbuild/bazel/blob/49b7d05c9d51371936616548a181f1cf12e95323/tools/build_defs/repo/jvm.bzl#L31-L30), also see the documentation in [java.bzl](https://github.com/bazelbuild/bazel/blob/4a74c5293050455e0ec0c965ea49eb3764cfe837/tools/build_defs/repo/java.bzl#L15). rules_scala has [scala versions](https://github.com/bazelbuild/rules_scala/blob/master/scala/scala_maven_import_external.bzl#L32) of these rules. However because they all use [ctx.download](https://docs.bazel.build/versions/master/skylark/lib/repository_ctx.html#download) none of them support authentication. For the implementation of `ctx.download` see [SkylarkRepositoryContext.java](https://github.com/bazelbuild/bazel/blob/8dcf9f442e5c97e51dcda2847fdf59f27d3abbe3/src/main/java/com/google/devtools/build/lib/bazel/repository/skylark/SkylarkRepositoryContext.java#L68).

To remove all fetched external dependences from `$(bazel info output_base)/external` run `bazel clean --expunge`

### Bazel-deps

A typical package manager (eg: Maven) does the following:

1. Find transitive dependencies - starting with a list of packages defined by the user, find all transitive packages (and their versions) required. This generates a much larger expanded set of packages.
1. Resolve dependency conflicts, such as if two packages depend on different versions of the same package.
1. Generate a package lock file that describes the resolved packages and their SHAs.
1. Download the expanded dependencies and place them in an appropriate place on your machine.

[bazel-deps](https://github.com/johnynek/bazel-deps/) does 1, 2 and 3. It resolves maven coordinates and their transitive dependencies, creating a package lock (sha file) with remote repository rules, and BUILD files that specify the dependency tree.

To create a sha file and generate BUILD files for 3rd party maven deps, run `gen_maven_deps.sh` eg:

```
gen_maven_deps.sh generate --repo-root ~/my-repo --deps dependencies.yaml --sha-file 3rdparty/workspace.bzl --verbosity info
```

`dependencies.yaml` determines which dependencies to generate a sha file and BUILD files for. Dependencies will be resolved using [coursier](https://github.com/coursier/coursier) against maven central, or any additional repositories. For additional repositories that require authentication, `<server>` settings in `~/.m2/settings.xml` will be matched via id and used. The dependency tree and BUILD rules will be created under the `//3rdparty/` prefix.

Transitive dependencies (ie: dependencies of those specified in `dependencies.yaml`) can be specified as either `runtime_deps` or `exports` of the `java_library` parent rule depending on the `transitivity` option in `dependencies.yaml`. In general `transitivity: runtime_deps` should be preferred as it enforces [strict deps](https://blog.bazel.build/2017/06/28/sjd-unused_deps.html) ie: a target can only reference classes it has defined as a dependency, and not transitive dependencies. Using [exports](https://docs.bazel.build/versions/master/be/java.html#java_library.exports) makes transitive dependencies available, which seems convenient and is the default behaviour in Maven/Gradle with `compile` scoped dependencies. But it effectively makes them part of your targets interface which means you can't change them without potentially breaking dependants that rely on them, and you can create [unnecessary rebuilds of ijars](https://groups.google.com/d/msg/bazel-discuss/gD5DiFQoefo/4_Rm6i9FIAAJ) when the transitive dependency changes. There is a example [here](https://docs.bazel.build/versions/master/build-ref.html#actual_and_declared_dependencies) of why declaring direct dependency rather than relying on transitive (indirect) dependencies is a good idea. If you are using rules_scala, see [below](#rules_scala) for how to enabling strict deps..

When using `transitivity: runtime_deps` individual dependencies can override this and provide explicit exports if required. This will be needed in some cases to make dependencies compile. Anything that is explicitly export must also be explicitly defined as a dependency, although a version isn't necessary unless you want to fix it, eg: `aws-java-sdk-core` will be the version specified by `aws-java-sdk-dynamodb`

```
dependencies:
  com.amazonaws:
    aws-java-sdk-core:
      lang: java
    aws-java-sdk-dynamodb:
      lang: java
      version: "1.11.192"
      exports:
      - "com.amazonaws:aws-java-sdk-core"
```

The above is necessary for `aws-java-sdk-dynamodb` to compile. It will place `com.amazonaws:aws-java-sdk-core` on the classpath of any target that references `//3rdparty/jvm/com/amazonaws:aws_java_sdk_dynamodb`

Dependencies in `dependencies.yaml` take a `lang` attribute which specifies which language rule to use and how the name is generated (eg: for scala deps the scala version is stripped). NB: transitive deps of a `scala` dep are assumed to be `java` - you can explicitly specify them as `scala` if you want to change this, although you may not necessarily need to.

By default, `strictVisibility: true`, which means dependencies in `dependencies.yaml` are declared with visibility public, and their transitive dependencies only have visibility within their package.

The remote repository rules created by bazel-deps fetch dependencies using `ctx.download` and set up a [bind](https://docs.bazel.build/versions/master/be/workspace.html#bind) in the external package with a `jar` prefix, eg:

```
bind(
  name = "jar/org/slf4j/slf4j_log4j12",
  actual = "@org_slf4j_slf4j_log4j12//jar:jar",
)
```

This maps `//external:jar/org/slf4j/slf4j_log4j12` to `@org_slf4j_slf4j_log4j12//jar`. To list all external rules (binds and artifacts) created by bazel-deps:

```
bazel query 'kind(jar_artifact, //external:*) union kind(bind, //external:*)' --output label_kind
```

See this alternative [workspace.bzl](https://github.com/andyscott/rules_scala_annex/blob/master/tests/workspace.bzl) that uses bazel-deps with `java_import_external` and `scala_import_external`. This relies on a fork of [bazel-deps](https://github.com/lucidsoftware/bazel-deps/commit/2b1f550f6a6ececdda4233a47b8429b9f98826f1), which adds `transitivity: deps` support and doesn't generate BUILD files.

#### bazel-deps and private repositories requiring auth

Via coursier bazel-deps can resolve dependencies from maven coordinates and find transitive dependencies using private repos. However the remote repository rules it generates in the sha file for fetching the dependencies are based on `ctx.download` and don't support authentication.

One way around this is to use bazel-deps to generate the BUILD files with the appropriate transitivity dependencies, and then modify the sha file and remove/rename the private dependencies, replacing them with an equivalent `maven_jar` rule which does support authentication. If the artifact name is the same, then the `//3rdparty/..` target will reference the external artifact fetched via `maven_jar` and have the correct set of `runtime_deps` as specified in the BUILD file.

Another [hack](https://github.com/johnynek/bazel-deps/issues/95#issuecomment-436818518) is to fall back to shelling out to `mvn` and using it to do the authentication.

Alternatively, and I'm yet to try this, it may be possible to make this work with [rules_jvm_external](https://github.com/bazelbuild/rules_jvm_external/).

### omit_foo style

The Nomulus project uses an `omit_foo` style for including dependencies, see [here](https://github.com/bazelbuild/bazel/issues/1952#issuecomment-272591653)

## Concepts

See [Concepts and Terminology](https://docs.bazel.build/versions/master/build-ref.html)

A package is defined as a directory containing a file named `BUILD` or `BUILD.bazel`.

Bazel will create symlinks in the workspace to bazel outputs. Binary output will be in `bazel-bin` under a directory named after the rule's label. For more info see [Output Directory Layout](https://docs.bazel.build/versions/master/output_directories.html)

Labels start with `//` but package names don't, ie: `my/app` is a package which contains the label `//my/app`. Relative labels cannot be used to reference targets in a different package.

[Rules](https://docs.bazel.build/versions/master/skylark/rules.html) define actions that map inputs to outputs. Each call to a rule returns no value but has the side effect of defining a new [target](https://docs.bazel.build/versions/master/skylark/rules.html#targets).

### Phases

Loading, analysis, and execution - see [Evaluation model](https://docs.bazel.build/versions/master/skylark/concepts.html#evaluation-model)

By design, loading a .bzl file has no visible side-effect, it only defines values and functions.

### Visibility

Default visibility is private, and the default for a package can be changed, eg: `package(default_visibility = ["//visibility:public"])`
If individual rules don't specify their visibility, the default for the package will be used.

See [Common definitions](https://docs.bazel.build/versions/master/be/common-definitions.html)

## BUILD files

[BUILD files](https://docs.bazel.build/versions/master/build-ref.html#BUILD_files) are small programs written in a minimal python dialect called Starlark (formerly known as Skylark).

Most BUILD files are declarations of rules. To encourage minimal BUILD definitions and a clean separation between code and data, BUILD files cannot contain function definitions, `for` or `if` statements. Instead functions can be declared in bazel extensions (ie: `.bzl` files) and loaded in - see [Loading an extension](https://docs.bazel.build/versions/master/build-ref.html#load)

## Best practice

Best practice is to add a `BUILD` file for each Java package ([ref](https://docs.bazel.build/versions/master/bazel-and-java.html)). Pants calls this the [1:1:1](https://www.pantsbuild.org/build_files.html#target-granularity) rule - 1 package contains 1 BUILD file which contains 1 target.

In [this scala example](https://github.com/johnynek/bazel-deps/blob/master/src/scala/com/github/johnynek/bazel_deps/BUILD) the `BUILD` file is used to specify a target for each individual file. This is probably to minimise compilation time because rules_scala is slow and doesn't yet do incremental compilation. Ideally targets will build in seconds rather than minutes, and large targets a split up. However, splitting the dependency graph like this for performance makes for a more awkward developer experience and hides a higher level logical dependency graph - see [this discussion](https://groups.google.com/forum/#!topic/bazel-discuss/3iUy5jxS3S0) and [also this discussion](https://github.com/bazelbuild/rules_scala/issues/328#issuecomment-417823637).

Bazel can introducing breaking changes between versions, so a good practice is to download a pinned version of bazel and run that.

## IntelliJ plugin

The [IntelliJ Bazel](https://ij.bazel.build/) plugin sets up an IntelliJ project according to the settings in the [project view](https://ij.bazel.build/docs/project-views.html) file (eg: `.bazelproject`). The plugin generates files under `.ijwb` which can be ignored by your VCS.

Regardless of the number of targets or directories in your project there will be two IntelliJ modules:

* `.project-data-dir` contains the `.ijwb` directory
* `.workspace`. Under `workspace` source and test folders will be created according to the settings in the project view

Sync will generate IDE info files (ie: IntelliJ project files) and resolve targets which includes building their source. It uses IntelliJ specific [aspects](https://docs.bazel.build/versions/master/skylark/aspects.html) to do this, which a different from the normal bazel commands.

After a sync, external java dependencies that have sources will be correctly linked. This isn't currently working for Scala sources, which have to be manually attached until [#476](https://github.com/bazelbuild/intellij/pull/476) is merged.

### Project view

`directories` - any directory listed here will be added as a content root to the `.workspace` module.
`targets` - The plugin will look for source folders of the targets specified here, and add them to the `.workspace` module. Source folders will be added for the languages specified in `workspace_type` and `additional_languages` (eg: `java`, `scala`). The more targets you have, the slower your Bazel sync will be. Wildcards can be specified here, eg: `//...` but Run configurations will only be generated for fully specified targets eg: `//example-lib:test`

## Data dependencies

Bazel runs binaries (including tests) in a [runfiles](https://docs.bazel.build/versions/master/skylark/rules.html#runfiles) directory, eg: for the target `//package1:tests` it would be `bazel-bin/package1/tests.runfiles/`. The runfiles directory contains symlinks to all dependencies needed by the target at run time.You can also inspect the manifest file which lists all the symlinks, eg: `tests.runfiles_mainfest`. If the binary needs a file at runtime, and not during build time, it can be specified as a [data dependency](https://docs.bazel.build/versions/master/build-ref.html#data). If data dependencies change, the binary won't be rebuilt, but any binaries/tests will be re-run. Note that this is not the same as the runtime java class path - for that use `runtime_deps` on `java_library` or `java_import`.

...."The relative path of a file in the runfiles tree is the same as the relative path of that file in the source tree or generated output tree".....

Data dependencies can be globs, in which case a symlink is created with same relative path in the runfiles directory as in the source directory, prefixed with the workspace, eg: `package1/native.dylib` can be referenced in `package1/BUILD` using `data = glob(["native.dylib"])`. If the workspace is called `myworkspace` then a symlink `myworkspace/package1/native.dylib` will be created in the runfiles directory pointing to `package1/native.dylib` in the source directory.

## Java rules

### java_library vs java_import

[java_library](https://docs.bazel.build/versions/master/be/java.html#java_library) compiles and links sources into a .jar file, but can also be used to export an existing jar with its dependants. Bazel-deps does this to export jars from remote repos. If `java_library` specifies exports, it shouldn't have src or deps attributes. This example defines `//third_party/java/soy` which can be used instead of having to repeat `@soy//jar` + all its runtime deps each time ([ref](https://groups.google.com/d/msg/bazel-discuss/gD5DiFQoefo/mPbYCBkmIAAJ)):

```
java_library(
    name = "soy",
    exports = ["@soy//jar"],
    runtime_deps = [
        "@aopalliance//jar",
        "@asm//jar",
        "@asm_analysis//jar",
        "@asm_commons//jar",
        "@asm_util//jar",
        "@guice//jar",
        "@guice_assistedinject//jar",
        "@guice_multibindings//jar",
        "@icu4j//jar",
        "//third_party:guava",
        "//third_party:jsr305",
        "//third_party:jsr330_inject",
    ],
)
```

[java_import](https://docs.bazel.build/versions/master/be/java.html#java_import) is for precompiled .jar files, and in addition to specifying exports and runtime_deps like `java_library`, can specify an existing source jar, eg:

```
java_import(
    name = 'jar',
    tags = ['maven_coordinates=com.almworks.sqlite4java:sqlite4java:1.0.392'],
    jars = ['com_almworks_sqlite4java_sqlite4java.jar'],
    srcjar = ":com_almworks_sqlite4java_sqlite4java-sources.jar",
)
```

For some more subtle differences between the two, see [bazel-deps #63](https://github.com/johnynek/bazel-deps/issues/63)

## Uber jar

The `java_binary` rule can build a uber jar, containing all dependencies' `.class` files, by building the target *name*_deploy.jar, see [java_binary](https://docs.bazel.build/versions/master/be/java.html#java_binary)

## Scala rules

[rules_scala](https://github.com/bazelbuild/rules_scala) provides Scala support.

rules_scala doesn't support incremental source compilation (eg: Zinc) so is slower than incremental compilers like [IntelliJ](https://blog.jetbrains.com/scala/2014/01/30/try-faster-scala-compiler-in-intellij-idea-13-0-2/) or sbt, eg: rebuilding a small change to a single scala test file takes 14 sec in bazel and 4 sec in IntelliJ. See the discussion on issue [#328](https://github.com/bazelbuild/rules_scala/issues/328#issuecomment-417743669).

[rules_scala_annex](https://github.com/andyscott/rules_scala_annex) uses zinc and does support incremental source compilation, however zinc is not provable reproducible (see this [comment](https://github.com/bazelbuild/rules_scala/issues/328#issuecomment-417778431)).

### rules_scala

rules_scala supports [strict-deps](https://github.com/bazelbuild/rules_scala#experimental-using-strict-deps) via `--strict_java_deps=ERROR`. This expands the classpath to include transitive (ie: indirect) dependencies and then detects when a transitive dependency is being relied on and emits a helpful error message with corrective action, rather than a cryptic compiler message (see [#235](https://github.com/bazelbuild/rules_scala/issues/235)). However, you may prefer the cryptic compiler message if you want to see where the dependency is being used, and sometimes it will prescribe deps when they aren't actually needed. Also a longer classpath, in the order of 100s of jars may make compilation time longer. Its probably worth using `--strict_java_deps=ERROR` when settings up dependencies and then remove it as mentioned [here](https://github.com/bazelbuild/rules_scala/issues/328#issuecomment-417778431).

rules_scala can identify unused dependencies with the following option:

```
scala_toolchain(
    name = "scala_toolchain_impl",
    unused_dependency_checker_mode = "error",
    visibility = ["//visibility:public"]
)
```

If strict-deps are enabled, this option will be ignored.

## Remote caching

Bazel supports [remote caching](https://docs.bazel.build/versions/master/remote-caching.html#bazel-remote-cache).

An example architecture for remote caching is to use an object store, and then have local proxies in an office and developer laptops - see [here](https://github.com/bazelbuild/bazel/pull/4889#issuecomment-400158426)

See [Initial attempt at direct s3 remote cache #4889](https://github.com/bazelbuild/bazel/pull/4889).

## Tests

By default only a summary of the test results will be shown, with a link to file containing the error log.

To output errors to stdout use `--test_output=errors`, or to output everything `--test_output=all`

## Questions

* How to download sources for 3rd party maven deps?
* How to resolve dependencies.yml easily? Need to publish it, and pull it down. [docker](https://github.com/johnynek/bazel-deps/pull/125) or [jar](https://github.com/johnynek/bazel-deps/issues/160) or [source](https://github.com/bazelbuild/BUILD_file_generator/blob/master/dev-scripts/dependencies/setup.sh)?
* How to download from authed repo with bazel-deps? [#95](https://github.com/johnynek/bazel-deps/issues/95)
* How to deploy from a monorepo? Via manual git commit message?

## Troubleshooting

`Unrecognized VM option 'CompactStrings'`

Occurs on Mac OS X when installing bazel 0.20 from homebrew using `brew install bazel`. The correct homebrew instructions are [here](https://docs.bazel.build/versions/master/install-os-x.html#step-2-install-the-bazel-homebrew-package)

To fix:

```
brew upgrade bazelbuild/tap/bazel
# use tap instead of core formula
brew tap-pin bazelbuild/tap
```

See [#32](https://github.com/bazelbuild/homebrew-tap/issues/32)

```
Error:Cannot run program "bazel" (in directory "/xxx/xxx"): error=2, No such file or directory
Error:Could not run Bazel info
```

Occurs when running bazel from IntelliJ

Navigate to Settings > Other Settings > Bazel Settings
Update Bazel binary location to /usr/local/bin/bazel

See [#320](https://github.com/bazelbuild/intellij/issues/230)

```
name 'scala_library' is not defined
```

Under tools/build_rules add the following to `prelude_bazel`:
```
load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library", "scala_macro_library","scala_binary", "scala_test")
load("@io_bazel_rules_scala//scala:scala_import.bzl", "scala_import")
```

```
ERROR: Source forest creation failed: /private/var/tmp/_bazel_tekumara/a741f74fc2dbcf2ec46c41d0bce3b0a3/execroot/my-repo/bazel-my-repo (File exists).
```

Add `bazel-*` to `.gitignore` and then rebuild.

```
(eval):1: _bazel: function definition file not found
```

When trying to use tab completion in zsh. To install `_bazel`:

```
mkdir -p ~/.zsh/completion/
curl https://raw.githubusercontent.com/bazelbuild/bazel/master/scripts/zsh_completion/_bazel > ~/.zsh/completion/_bazel
```

Then modify fpath in ~/.zshrc BEFORE calling oh-my-zsh (which runs compinit):

```
fpath=($fpath ~/.zsh/completion/)
```

```
Symbol 'term cats.kernel' is missing from the classpath.
```

Declare cats.kernel as an explicit dependency and export it from cats-core, eg:

```
  org.typelevel:
    cats:
      lang: scala
      modules: [ "kernel" ]
      version: "1.4.0"
    cats-core:
      exports:
      - "org.typelevel:cats-kernel"
      lang: scala
      version: "1.4.0"
```

```
 Class com.amazonaws.regions.Regions not found - continuing with a stub.
```

Declare aws-java-sdk-core as an explicit dependency and export it from aws-java-sdk-dynamodb, eg:

```
  com.amazonaws:
    aws-java-sdk-core:
      lang: java
      version: "1.11.192"
    aws-java-sdk-dynamodb:
      lang: java
      version: "1.11.192"
      exports:
      - "com.amazonaws:aws-java-sdk-core"
```

```
error: object apache is not a member of package org
```

..and when navigating to the file in IntelliJ you will see the ijar only. Add the relevant dependency to the package's BUILD file (in this case commons_codec).

## Buildozer

Install: `go get github.com/bazelbuild/buildtools/buildozer`

See [docs](https://github.com/bazelbuild/buildtools/blob/master/buildozer/README.md)

Buildozer changes will be piped through [buildifer](https://github.com/bazelbuild/buildtools/buildifier) which formats the BUILD file.

To run buildifer manually:

```
buildifier path/to/file
```

## Determine targets needing a rebuild

TODO

## Determine targets that use file

```
file=proj/src/main/scala/my/org/encoder/common/Encoder.scala
file_label=$(bazel query "$file")
bazel query "attr('srcs', $file_label, ${file_label//:*/}:*)"
```

[ref](https://docs.bazel.build/versions/master/query-how-to.html#what-rule-target-s-contain-file-path-to-file-bar-java-as-a-sourc)
