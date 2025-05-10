# github terraform provider

This happens if required linear history hasn't been disabled first:

> 422 Validation Failed [{Resource:Repository Field:merge_commit_allowed Code:invalid Message:Sorry, you need to allow either squash or rebase merge strategies, or both. (protected_branch_policy)}]

The equivalent message in the UI is:

> You must select squashing or rebasing option. This is because linear history is required on at least one protected branch.

I've manually unticked it for pyapi-template.

## Issues

- [[BUG]: No warning/error on conflicting resource properties for github_repository](https://github.com/integrations/terraform-provider-github/issues/2264#issuecomment-2848370859)
- [[BUG]: Validation failed when changing merge strategies and linear history is enabled](https://github.com/integrations/terraform-provider-github/issues/2647)
- [[BUG]: Changes are not being detected on github_repository](https://github.com/integrations/terraform-provider-github/issues/2646)
