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

[local_exec Provisioner](https://www.terraform.io/docs/language/resources/provisioners/local-exec.html) invokes a local executable after a resource is created. If `when = destroy` is specified, the provisioner will run when the resource it is defined within is destroyed (see [Destroy-Time Provisioners](https://www.terraform.io/docs/language/resources/provisioners/syntax.html#destroy-time-provisioners)).

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
