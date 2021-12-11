# TeamCity

## Versioned Settings

### Synchronization

When Synchronization is enabled, project settings & build configurations will be synchronized from the Kotlin source on every push to the default branch of the chosen VCS root (or when the default branch or VCS root changes). Check the `Current status` section of the Versioned Settings pane to see the latest commit that was synchronized.

### Use settings from VCS

When `Use settings from VCS` is enabled, build configuration changes in a commit will be applied to the UI once the build is triggered. Changes to VCS roots, snapshot dependencies, or added/deleted/renamed build configurations can only be applied from the default branch See [Defining Settings to Apply to Builds](https://www.jetbrains.com/help/teamcity/2021.1/storing-project-settings-in-version-control.html#Defining+Settings+to+Apply+to+Builds) for a list of which changes can and can't take effect on the build.

Changes that can't be applied will warn with:

```
Unsupported change of build features in the build configuration 'Hello World' has been detected in the settings taken from VCS, the current settings from TeamCity server will be used instead

Inapplicable versioned settings found, yet all other build settings from VCS were successfully loaded
```

or

```
      Unsupported change of version control settings in the build configuration 'Awesome Project' has been detected in the settings taken from VCS, the current settings from TeamCity server will be used instead
        Added version control setting: https://github..com/app/awesome#refs/heads/main
      Inapplicable versioned settings found, yet all other build settings from VCS were successfully loaded
```

To test these changes, use the Edit VCS Root page to change the VCS root to point to your feature branch. It might take a minute for you changes to appear in the TeamCity UI. Restore main/master as the default branch after testing.

## Kotlin DSL Sources / API Docs

To download the sources for the Kotlin Teamcity DSL classes run:

```
mvn -U dependency:sources
```

See also the [public teamcity server kotlin dsl api docs](https://teamcity.jetbrains.com/app/dsl-documentation/index.html).

## Generating the build configuration XML

To generate XML configs in ./teamcity/target/generated-configs

```
mvn teamcity-configs:generate -f .teamcity/pom.xml
```

This requires having a pluginRepository configured that hosts `org.jetbrains.teamcity:teamcity-configs-maven-plugin:2020.2.2`, eg:

```xml
  <pluginRepositories>
    <pluginRepository>
      <id>central</id>
      <name>teamcity-repository</name>
      <url>https://download.jetbrains.com/teamcity-repository</url>
      <snapshots>
        <enabled>true</enabled>
      </snapshots>
    </pluginRepository>
  </pluginRepositories>
```

## View current build configuration settings

From Build Configuration Home -> More -> Settings. See also View DSL.

## Triggers and dependencies

A trigger is needed to start a build, but if a build has dependencies it will wait in the queue with status "Build dependencies have not been built yet" until its dependency complete and then it runs. See the "Dependencies" tab on the queued build, or the Build Chains page of the Build Configuration for details.

The VCS trigger will trigger a build when the specified branch and path is changed in git. When all the builds in a build chain have the same VCS trigger the builds will queue (see above).

The [Finish Build Trigger](https://www.jetbrains.com/help/teamcity/configuring-finish-build-trigger.html) starts a build configuration when another completes. When using the Finish Build Trigger you should probably also use snapshot dependencies to avoid races. If a branch filter is not specified in Kotlin, this trigger runs on the default branch (ie: `+:<default>`) only.

I've found it also doesn't trigger at all without a snapshot dependency (still true?)

## Failed to start vs cancelled builds

[Failed to start builds](https://www.jetbrains.com/help/teamcity/build-state.html#Failed+to+Start+Builds) usually indicate a configuration error.

## Sequence vs sequential

`sequence` is part of [teamcity-pipelines-dsl](https://github.com/JetBrains/teamcity-pipelines-dsl) and was merged into TeamCity version 2019.2 as [`sequential`](https://www.jetbrains.com/help/teamcity/kotlin-dsl.html#Build+Chain+DSL+Extension).

## Troubleshooting

### Verbose build logs

On the Build logs tab change _All Messages_ -> _Verbose_.

### Build settings have not been finalized

TeamCity is generating settings for the project from Kotlin.

### Pending changes are not detected

First check the VCS root and see when the period scheduler last ran (via Edit configuration - General Settings - Version Control Settings), eg:

```
(git) awesome-app belongs to Team Awesome / Amazing App
    Commit hook is inactive
    Latest check for changes: 14:54 (periodical run by the schedule)
    Changes checking interval: 1m
```

Manually trigger a check for changes via _Actions - Check for pending changes_ (might take a minute or two). This should bring the periodic scheduler back to life.

If the commit hook is inactive, reinstate it.

### Pending changes but builds are not triggered

Make sure the build configuration has a trigger. Check the [trigger rules](https://www.jetbrains.com/help/teamcity/configuring-build-triggers.html) used to understand when they fire.

If you have a vcs trigger with a branch filter, include the non-refs path as well as the refs/head path, eg:

```
+:refs/heads/main
+:main
```

Changes to a branch filter in Kotlin will take effect once the UI has been updated, ie: once the change containing the updated branch filter has been detected and applied by Teamcity, the next change will trigger using the new branch filters.

### VCS trigger rules are ignored

Check how the build was triggered on the Build page. It may be because of a snapshot dependency rather than a vcs trigger.

### Build is triggered twice

If a build has a VCS trigger and a snapshot dependency it will be triggered twice.

### Failed to perform checkout .... failed to remove ... permission denied

If you run docker/docker-compose directly, the container runs as root, it bind mounts the checkout directory and writes to it, then the files will be created as root. When the agent tries to perform `git clean` it won't be able to remove the root owned files and the checkout will fail.

To resolve this:

- mount and write to a docker volume instead of the checkout directory
- set the docker run user to $UID (ie: the teamcity user) so files are owned by teamcity

Script build steps use the docker wrapper and so don't have this problem. As a final build step the docker wrapper [chowns all writable paths, include the checkout directory](https://www.jetbrains.com/help/teamcity/docker-wrapper.html#Restoring+File+Ownership+on+Linux) using:

```
docker run -u 0:0 --rm --entrypoint chown $volume_mounts busybox -R $uid:$gid $writable_paths
```

You'll see this in the verbose logs:

```
Docker wrapper: restore directory ownership
11:41:31
    Set ownership to 1001/1001 for "/opt/buildagent/work/6dc2c78e898ab533" "/opt/buildagent/temp/agentTmp" "/opt/buildagent/temp/buildTmp" "/opt/buildagent/system"
```

### There are no compatible agents which can run this build

Check the Agents Compatibility page. Both explicit and implicit requirements must be met.

If the `build.vcs.number` implicit requirement is not met check that you have a VCS root defined. `build.vcs.number` is a [predefined build parameter](https://www.jetbrains.com/help/teamcity/predefined-build-parameters.html#Server+Build+Properties) that exists if there is only a single VCS root in the configuration.

## References

[Kotlin DSL](https://www.jetbrains.com/help/teamcity/kotlin-dsl.html)
