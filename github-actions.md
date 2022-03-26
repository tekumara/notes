# GitHub Actions

## Concepts

Steps within a job execute on the same runner and can share the filesystem.
Jobs execute across different runners but can [access artefacts from other jobs](https://help.github.com/en/actions/configuring-and-managing-workflows/persisting-workflow-data-using-artifacts#passing-data-between-jobs-in-a-workflow). By default, a workflow with multiple jobs will run those jobs in parallel. Jobs can be made to run sequentially using the [needs](https://docs.github.com/en/actions/learn-github-actions/managing-complex-workflows#creating-dependent-jobs) keyword.

Workflows are made up of one or more jobs. Workflows are indepedently scheduled or activated by an [event](https://help.github.com/en/actions/configuring-and-managing-workflows/configuring-a-workflow#triggering-a-workflow-with-events) eg: a push to a specific branch (optionally filtered by [path](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#onpushpull_requestpaths)), or the [completion of another workflow](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#workflow_run).

For more info see [Core concepts for GitHub Actions](https://help.github.com/en/actions/getting-started-with-github-actions/core-concepts-for-github-actions)

## Runners

The GitHub ubuntu-latest runner environment is described [here](https://github.com/actions/virtual-environments/blob/ubuntu18/20200430.1/images/linux/Ubuntu1804-README.md)

## Debugging

To [enable step debug logging](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging#enabling-step-debug-logging), create a secret in the repo `ACTIONS_STEP_DEBUG` set to `true`
