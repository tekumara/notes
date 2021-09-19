# terraform

## Multiple environments

For handling prod/test environments use variables and a var file for each environment. (Recommended)

Alternatively make your whole stack into a module with all of its config coming through as variables. Then have separate folders for each environment that reference the modules. But requires repeating some things like providers and variables.

## Backend per environment

This requires a re-initialising local state for each environment:

```
terraform init -reconfigure -backend-config=backends/$env.conf
```

`-reconfigure` is needed to ignore existing state from other backends.

## Single backend with Workspaces

Workspaces are namespaces that partition state within a **single** backend. You probably want to use this for local backends.

When using the s3 backend a single bucket is shared between environments. This implies:

- environments are dependent on the availability of the state bucket's AWS region
- cross-account access for the bucket (ie: bucket policy, and kms key access)
- there is a single backend config rather than one per environment (make things a little simpler)

State objects will be located at `workspace_key_prefix/workspace_name/key` by default `workspace_key_prefix` is `env:` but can be configured.

HashiCorp recommends an admin service account for the state bucket see [Multi-account AWS Architecture](https://www.terraform.io/docs/language/settings/backends/s3.html#multi-account-aws-architecture).

References:

- [Workspaces](https://www.terraform.io/docs/language/state/workspaces.html)
