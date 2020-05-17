# GitHub Actions

## Concepts

Steps within a job execute on the same runner and can share the filesystem.
Jobs execute across different runners but can [access artefacts from other jobs](https://help.github.com/en/actions/configuring-and-managing-workflows/persisting-workflow-data-using-artifacts#passing-data-between-jobs-in-a-workflow). Jobs can run at the same time in parallel or run sequentially depending on the status of a previous job.

Workflows are made up of one or more jobs and can be scheduled or activated by an [event](https://help.github.com/en/actions/configuring-and-managing-workflows/configuring-a-workflow#triggering-a-workflow-with-events).

For more info see [Core concepts for GitHub Actions](https://help.github.com/en/actions/getting-started-with-github-actions/core-concepts-for-github-actions)