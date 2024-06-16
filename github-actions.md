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

## Reusable Workflows

Allow a job, or group of jobs, to be reused across workflows. This allows a tree of jobs to be created, eg: see the overview diagram in [Reusing workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows). Reusable workflows must have the `workflow_call` trigger, and support parameters. Reusable workflows are called by [jobs.<job_id>.uses](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_iduses).

## Composite actions

Allow a step, or set of steps, to be reused across jobs.

## Chaining workflows

1. `workflow_run` - [triggers a dependent workflow](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_run) when a upstream workflow executes or completes. The success or failure of the upstream workflow is available a conclusion to the dependent workflow.
1. `workflow_call` - see [reusable workflows](#reusable-workflows) above
1. [workflow_dispatch](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch) - allows a workflow to be manually triggered, eg: via `gh workflow run` or the [dispatches endpoint](https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#create-a-workflow-dispatch-event). Dispatched workflows run on a branch or tag. They don't generate checks.

## pull_request

- Won't run if there's a merge conflict, resolve that first.
- Have write permissions to the repo, if run from a branch in the same repository, but not from external forks.

## pull_request_target

Workflows triggered via a `pull_request_target` event:

- have write permission to the target repository
- can access to target repository secrets
- run in the context of the base of the pull request, not the merge commit, to prevent execution of unsafe code in the PR, ie: [actions/checkout will checkout main](https://github.com/actions/checkout/pull/321#issuecomment-702961848) for a PR targeting main.
- don't require [explicit approval when running for first time contributors to the repo](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository#controlling-changes-from-forks-to-workflows-in-public-repositories)

Useful for workflows that label or comment on PRs from forks. Avoid if you need to build or run code from the pull request, although you can do it, eg:

```yaml
- uses: actions/checkout@v4
  with:
    # Checkout the fork instead of the target
    repository: ${{ github.event.pull_request.head.repo.full_name }}

    # Checkout the branch made in the fork
    ref: ${{ github.head_ref }}
```

See

- [Events that trigger workflows - pull_request_target](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#pull_request_target)
- [Keeping your GitHub Actions and workflows secure Part 1: Preventing pwn requests](https://securitylab.github.com/research/github-actions-preventing-pwn-requests/)
- [git-auto-commit-action - Use in forks from public repositories](https://github.com/stefanzweifel/git-auto-commit-action?tab=readme-ov-file#use-in-forks-from-public-repositories)
- [autofix.ci - uses a github app rather than pull_request_target](https://autofix.ci/)
- [Allowing changes to a pull request branch created from a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/allowing-changes-to-a-pull-request-branch-created-from-a-fork)

## Troubleshooting

### Workflow does not have 'workflow_dispatch' trigger

The dispatch event runs the workflow at commit `ref`. Make sure the workflow exists at that ref.

### Workflow dispatch does not trigger

You can't use a GITHUB_TOKEN to
