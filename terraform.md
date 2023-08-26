# terraform

## Multiple environments

For handling prod/test environments use variables and a var file for each environment. (Recommended)

Alternatively make your whole stack into a module with all of its config coming through as variables. Then have either:

- separate folders for each environment that reference the modules. This requires repeating some things like providers and variables.
- for each module, use a different provider which assumes the appropriate role. This is nicer, but assumes you can hard-code the role.

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
- cross-account access for the bucket (ie: resource policies for the bucket and kms key, or a role than can be assumed)
- there is a single backend config rather than one per environment. This make things a simpler and quicker to initialise because there's no need to reinitialise per environment. It also more flexible and enables single workspace multi account approaches, ie: a single stack with an AWS provider per account and associated resources.

State objects will be located at `workspace_key_prefix/workspace_name/key`. By default `workspace_key_prefix` is `env:` but can be configured.

HashiCorp recommends an admin AWS account for the state bucket see [Multi-account AWS Architecture](https://www.terraform.io/docs/language/settings/backends/s3.html#multi-account-aws-architecture) to reduce risk if the production infra is exploited.

## Roles

Terraform allows separate roles for

- read/write state
- roles in th etarget account to create/update/delete resources.

References:

- [Workspaces](https://www.terraform.io/docs/language/state/workspaces.html)

## Render bucket policy

```
terraform plan -var-file vars-prod.tfvars -out=plan
terraform show -json plan | jq > plan.json
jq '.planned_values.root_module.resources[] | select(.address=="aws_s3_bucket_policy.flows_bucket_policy") | .values.policy | fromjson' plan.json
```

## Escape hatches

[External Data Source](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/data_source) will call an external program to generate data when referenced.

[null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) will be recreated when trigger values change.

[local_exec Provisioner](https://www.terraform.io/docs/language/resources/provisioners/local-exec.html) invokes a local executable after a resource is created. It is not called on modification. If `when = destroy` is specified, the provisioner will run when the resource it is defined within is destroyed (see [Destroy-Time Provisioners](https://www.terraform.io/docs/language/resources/provisioners/syntax.html#destroy-time-provisioners)).

If local_exec fails then the resource will be tainted, and therefore recreated. If it's an expense resource to recreate, then use local_exec instead a `null_resource`. The other advantage is the `null_resource` can be explicitly tainted and just the local-exec will be rerun.

## Scope

Locals are scoped to the whole module (ie: directory they're in)

## Avoiding secrets in state

Data sources and resources store their values in state.

Instead of retrieving the sensitive value using a data source, pass it in as a variable and use it only in provider, provisioner, and connection blocks. This works because those features do not require storage in state.

Alternatively, fetch the secret in one of those blocks, eg: a local_exec provisioner:

```
resource "aws_db_instance" "rds_example" {

   ...
   rds details etc ...
   ...
   password = "temporarypasswordOverriddenBelow"
   ...

    provisioner "local-exec" {
        command = "bash -c 'DBPASS=$$(openssl rand -base64 16) ; aws rds modify-db-instance --db-instance-identifier ${self.id} --master-user-password $${DBPASS} --apply-immediately"
    }
}
```

## Recreating resources

`terraform apply -replace` will delete and recreate a resource. Useful for rotating a random_password or tls_private_key resource.

eg:

```
terraform apply -replace 'module.warehouses["PROD_JAFFLES_WH"].snowflake_warehouse.warehouse'
```

NB: In previous versions of terraform this was known as tainting.

## Plan and state inspection

To extract the current state as json

```
terraform show -json
```

To extract the plan as json

```
terraform plan -var-file vars-prod.tfvars -out=plan && terraform show -json plan | jq > plan.json
```

To see a planned bucket policy as json

```
jq '.planned_values.root_module.resources[] | select(.address=="aws_s3_bucket_policy.myawesome_bucket_policy") | .values.policy | fromjson' plan.json
```

Or from a child module select the secret policy:

```
jq '.planned_values.root_module.child_modules[].resources[] | select(.address|endswith("aws_secretsmanager_secret.snowflake_user")) | .values.policy | fromjson' plan.json
```

To see the current state as json

```
jq '.values.root_module.child_modules[].resources[]' state.json
```

## Troubleshooting

### X has been deleted

Before the plan terraform will do a refresh and compare the state file against actual AWS resources. If resources in the state file no longer exist, terraform will report the resource "has been deleted". If this seems wrong, check that you are in the right AWS region and account.

### Error: Unsupported argument

```
Error: Unsupported argument

  on vars-prod.tf line 1:
   1: env = "prod"

An argument named "env" is not expected here.
```

variables must be specified in a `.tfvars` file.

### The "for_each" value depends on resource attributes that cannot be determined until apply

Follow the dependency chain backwards and locate resources that don't yet exist or have unknown values.

### This value does not have any indices

When used on a resource attributed of type `tfsdk.ListNestedAttributes`.

Wrap the attribute with `tolist(..)`

### Invalid type for provider

If this is accompanied by a `Optional object type attributes are experimental` error, fix that to resolve the `Invalid type for provider` error.

### Error: error configuring S3 Backend: IAM Role (arn:aws:iam::...) cannot be assumed

This is a generic error caused by failure to assume the role for the backend.
To get an more specific error message enable debug logging, eg: `TF_LOG=DEBUG terraform ..`

### Error: SSOProviderInvalidToken: the SSO session has expired or is invalid

Generate an sso token in _~/.aws/sso/cache_: `aws sso login --profile <your_profile>`

### Error: Invalid provider configuration

> │ Error: Invalid provider configuration
> │
> │ Provider "registry.terraform.io/hashicorp/aws" requires explicit configuration. Add a provider block to the root module and configure the provider's required
> │ arguments as described in the provider documentation.

This can happen when all providers have an alias ([ref](https://github.com/hashicorp/terraform-provider-aws/issues/30902#issuecomment-1522160649)) and there are `data` or `resource` statements that don't specify a provider. In this case the default empty provider is used but is invalid.

### Error: configuring Terraform AWS Provider: no valid credential sources for Terraform AWS Provider found

The provider does not have valid creds. Check it has been correctly defined, and any needed credentials are available as environment variables or via the IMDS.
