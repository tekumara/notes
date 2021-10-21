# TeamCity Critique

1. Using a general purpose language (Kotlin) provides too many degrees of freedom. Many things can and do go wrong.
1. Support for pipelines as code is second class, eg: some types of changes can only be made on the default branch (eg: master) which makes iteration slow
1. Poor documentation on the Kotlin DSL and how it maps to the UI.
1. The mapping of Kotlin pipelines to UI is unintuitive. Sometimes the UI applies patches and it's not clear why.
1. The UI isn't consistent - features of the UI will change based on configuration, eg: sometimes the Parameters for a build are visible, sometimes not, and there's no indication of the different states.
1. Teamcity is generally non-intuitive - a specific example is Tokens are meant to be inheritable from parent projects, but not automatically. Instead you have to manually copy them to child projects.
1. Error messages don't have explanations, and the code is not open-source so can't be understood, eg: "Unsupported change of build features in the build configuration" - what does this mean?
1. Basic features require explicit configuration, eg: status checks, vcs triggers. These just work in other systems.
1. Low visibility when things go wrong, eg: status checks fail.
1. Chaining builds together via dependencies is unintuitive, eg: manually triggering a build will run its dependencies first. Usually you'd expect to trigger the head of the build chain and if it succeeds it kicks off its children.
1. No link in the UI from the TC build to the github commit
1. Webhooks die randomly
1. Pending changes don't always get picked up immediately, sometimes up to 3 mins (even with hooks enabled)
1. After trigger, gets stuck in queue for 1 min
1. Incorrectly configured build specs can easily trigger multiple builds for the same commit, eg: one for PR, one for branch.

==> a lot of time wasted
