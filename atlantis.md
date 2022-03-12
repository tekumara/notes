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

## Gotchas

`atlantis apply` will apply all projects independently, ie: the failure of a project won't stop the others applying. See [#2076](https://github.com/runatlantis/atlantis/issues/2076)

If this is a concern, then run the projects separately, eg: `atlantis apply -p test` followed by `atlantis apply -p prod`

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

### The default workspace is currently locked by another command that is running for this pull request.

In order to run parallel plans, each project must have it's own workspace.
