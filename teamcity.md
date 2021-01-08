# TeamCity

## Versioned Settings

### Synchronization

When Synchronization is enabled, project settings & build configurations will be synchronized from the Kotlin source on every push to the default branch of the chosen VCS root (or when the default branch or VCS root changes). Check the `Current status` section of the Versioned Settings pane to see the latest commit that was synchronized.

### Use settings from VCS

When `Use settings from VCS` is enabled, build configuration changes in a commit will be applied to that build. Only a subset of changes can be applied. They are generally changes that effect a single build. Changes that can't be applied will warn with:

```
Unsupported change of build features in the build configuration 'Hello World' has been detected in the settings taken from VCS, the current settings from TeamCity server will be used instead

Inapplicable versioned settings found, yet all other build settings from VCS were successfully loaded
```

To take effect this change must be merged to the default branch, or change the default branch to point to this branch.

See [Defining Settings to Apply to Builds](https://www.jetbrains.com/help/teamcity/2020.1/storing-project-settings-in-version-control.html#Defining+Settings+to+Apply+to+Builds) for a list of which changes can and can't take effect on the build.

## View current build configuration settings

From Build Configuration Home -> More -> Settings. See also View DSL.
