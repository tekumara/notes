# atlantis

If you create an atlantis.yaml it must have a projects section otherwise no projects will be found.

[Custom commands](https://www.runatlantis.io/docs/custom-workflows.html#running-custom-commands) run in the directory that contain the checked out repo, so can reference scripts from the repo. The output of the custom command is captured and displayed on the PR. See [this example](https://github.com/tekumara/atlantis-example/pull/1#issuecomment-1046134758) running `env` during the plan stage.

A [`default` workflow](https://www.runatlantis.io/docs/server-side-repo-config.html#reference) is defined with the following steps:

```
workflows:
  default:
    plan:
      steps: [init, plan]
    apply:
      steps: [apply]
```

Pre and post-workflow commands can be defined in the server-side config (ie: _repos.yaml_). Their output is not recorded on the PR.

Atlantis [auto plans](https://www.runatlantis.io/docs/autoplanning.html) by default, ie: runs plan on every commit for the projects which have file changes.

Additional features:

- [lock](https://www.runatlantis.io/docs/locking.html) the workspace whilst a plan is unapplied to avoid conflicts between PRs
- support for terraform workspaces. These can be planed/applied in [parallel](https://github.com/runatlantis/atlantis/blob/37dad2bb15ee8759f82258b41d35267a43c349c5/CHANGELOG.md).
- [plan only](https://github.com/runatlantis/atlantis/pull/1230) mode if you have another pipeline that does the apply.
- policy checking via conftest
- plan/apply multiple projects in a single command using [regexes](https://github.com/runatlantis/atlantis/pull/1419)
- `automerge: true` will merge the PR once applied. Will squash merge if that's the only option. The squashed message will contain the pr title, description, and git commit messages.

## Commands on the PR

`atlantis --help` will show possible commands
`atlantis version` will [show the terraform version](https://github.com/runatlantis/atlantis/blob/90e92e3a13e8cb7f07ae6b0935b1a0bdf90be927/server/core/runtime/version_step_runner.go) not the atlantis version.
`atlantis plan -p myproject -- -replace=aws_dynamodb_table.dynamodb_table` to destroy and recreate a resource. Anything after `--` is passed to terraform.
`atlantis plan -p myproject -- -destroy` to remove myproject (run before deleting the project's files)

## Helm

```
helm repo add runatlantis https://runatlantis.github.io/helm-charts
helm install -f https://raw.githubusercontent.com/runatlantis/helm-charts/main/charts/atlantis/test-values.yaml my-atlantis runatlantis/atlantis --debug --version 3.12.11
```

To specify a custom image, set `image.repository` and `image.tag`.

The chart installs:

- Pod, Service, Ingress
- ServiceAccount, Secret, ConfigMap,
- StatefulSet

## Gotchas

`atlantis apply` will apply all projects independently, ie: the failure of a project won't stop the others applying. See [#2076](https://github.com/runatlantis/atlantis/issues/2076)

If this is a concern, then run the projects separately, eg: `atlantis apply -p test` followed by `atlantis apply -p prod`

By default atlantis will require any approver. To only allow approvers that are code owners, set the branch protection rules to `Require review from Code Owners` and in atlantis.yaml set

```
apply_requirements: [mergeable]
```

If you want to ensure PRs are merged after apply, set `automerge`

### Order

eg: _atlantis.yaml_

```
- name: test
  dir: .
  workflow: test
  workspace: test
- name: prod
  dir: .
  workflow: prod
  workspace: prod
```

`atlantis plan` will run in project order, ie: test then prod.
`atlantis apply` will run in workspace name alphabetical order, ie: prod then test.

### The default workspace is currently locked by another command that is running for this pull request

In order to run parallel plans, each project must have it's own workspace.

## Troubleshooting

Empty plan with no text - check that you have a valid version of terraform in atlantis.yaml

Plans on push but commands are ignored - make sure the [webhooks](https://www.runatlantis.io/docs/configuring-webhooks.html) are receiving the correct events.
