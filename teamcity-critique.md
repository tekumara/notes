# TeamCity Critique

1. Using a general purpose language (Kotlin) provides too many degrees of freedom. Many things can and do go wrong.
1. Support for pipelines as code is second class, eg: some types of changes can only be made on the default branch (eg: master) which makes iteration slow
1. The UI is complex and unintuitive
1. Essential features require complex setup, eg: setting up Github status checks
1. Error messages don't have explanations, and the code is not open-source so can't be understood, eg: "Unsupported change of build features in the build configuration"
1. Basic features have to be built from scratch, eg: status checks, vcs triggers.
1. Low visibility when things go wrong, eg: status checks fail.
1. Dependencies are unintuitive - eg: when manually triggering a build it will run its dependencies first. Usually you'd expect to trigger the head of the build chain and if it succeeds it kicks off its children.
1. No link in the UI from the TC build to the github commit
1. Webhooks die randomly
1. Pending changes don't always get picked up immediately
1. Incorrectly configued build specs can easily trigger multiple builds for the same commit, eg: one for PR, one for branch. 

==> a lot of time wasted
