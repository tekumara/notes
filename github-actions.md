# GitHub Actions

## Concepts

Steps within a job execute on the same runner and can share the filesystem.
Jobs execute across different runners but can [access artefacts from other jobs](https://help.github.com/en/actions/configuring-and-managing-workflows/persisting-workflow-data-using-artifacts#passing-data-between-jobs-in-a-workflow). By default, a workflow with multiple jobs will run those jobs in parallel. Jobs can be made to run sequentially using the [needs](https://docs.github.com/en/actions/learn-github-actions/managing-complex-workflows#creating-dependent-jobs) keyword.

Workflows are made up of one or more jobs. Workflows are independently scheduled or activated by an [event](https://help.github.com/en/actions/configuring-and-managing-workflows/configuring-a-workflow#triggering-a-workflow-with-events) eg: a push to a specific branch (optionally filtered by [path](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#onpushpull_requestpaths)), or the [completion of another workflow](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#workflow_run).

For more info see [Core concepts for GitHub Actions](https://help.github.com/en/actions/getting-started-with-github-actions/core-concepts-for-github-actions)

## Runners

The GitHub ubuntu-latest runner environment is described [here](https://github.com/actions/virtual-environments/blob/ubuntu18/20200430.1/images/linux/Ubuntu1804-README.md)

## Debugging

To [enable step debug logging](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging#enabling-step-debug-logging), create a secret in the repo `ACTIONS_STEP_DEBUG` set to `true`

## Status badges

See [Adding a workflow status badge](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/adding-a-workflow-status-badge). If the status is stale, add the appropriate event to the url, eg: `..badge.svg?event=release`

## Actions checkout using the merge ref by default

`pull/N/merge` is a special reference that GitHub creates for each pull request. It's the PR merged into the target branch and is used to check for merge conflicts. It's also what actions/checkout uses by default, [which is surprising](https://github.com/actions/checkout/issues/504), eg: in the `Run actions/checkout` logs you'll see:

```
Checking out the ref
  /usr/bin/git checkout --progress --force refs/remotes/pull/126/merge
  Note: switching to 'refs/remotes/pull/126/merge'.
```

To [checkout pull request HEAD commit instead of merge commit](https://github.com/actions/checkout?tab=readme-ov-file#checkout-pull-request-head-commit-instead-of-merge-commit):

```yaml
- uses: actions/checkout@v4
  with:
    ref: ${{ github.event.pull_request.head.sha }}
```
