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

## Taints

`terraform taint` will make a resource for recreation. Useful for rotating a random_password or tls_private_key resource.

eg:

```
terraform taint 'module.warehouses["PROD_JAFFLES_WH"].snowflake_warehouse.warehouse'
```

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
