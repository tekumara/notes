# terraform

## Multiple environments

For handling prod/test environments use variables and a var file for each environment. (Recommended)

Alternatively make your whole stack into a module with all of its config coming through as variables. Then have separate folders for each environment that reference the modules. But requires repeating some things like providers and variables.

## Backend per environment

This requires re-initialising local state when switching between environments:

```
terraform init -reconfigure -backend-config=backends/$env.conf
```

- `-reconfigure` overwrites existing local state (from other previously used backends)
- `-backend-config` points to the environment's backend. A file per backend/environment is needed.

Initialising takes about 7 secs.

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

## Render bucket policy

```
terraform plan -var-file vars-prod.tfvars -out=plan
terraform show -json plan | jq > plan.json
jq '.planned_values.root_module.resources[] | select(.address=="aws_s3_bucket_policy.flows_bucket_policy") | .values.policy | fromjson' plan.json
```
