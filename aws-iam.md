# AWS IAM

## ID

```
aws sts get-caller-identity
```

or

```
python -c 'import boto3; client = boto3.client("sts"); print(client.get_caller_identity()["Arn"])'
```

## IAM arns

`arn:aws:iam::123456789012:root` the root user ie: the AWS account itself, in this case account `123456789012`

## InstanceProfile vs Role

InstanceProfile - associated with a Role, and can be attached to an EC2 instance so the EC2 instance assumes that role.

## Roles

Describe role ARN, MaxSessionDuration, trust relationships for assuming the role (ie: AssumeRolePolicyDocument) etc.

```
aws iam get-role --role-name $(ROLE_NAME)
```

List all roles

```
aws iam list-roles | jq -r '.Roles[].RoleName'
```

List all roles, and their trust policy (aka trusted entities)

```
aws iam list-roles | jq '.Roles[] | [.RoleName, .AssumeRolePolicyDocument]'
```

## Policies

Inline policies are embedded in the role. Managed policies are separate and can be attached to multiple roles.
The type of a policy is visible in the AWS console on the role to which it is attached.

Managed policies are [versioned](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-versioning.html). The default version is the currently active version, ie: the version in affect for all principal entities (users, groups, and roles) the managed policy is attached to.

See [Managed policies and inline policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html)

In CloudFormation, inline policies can be specified along with the role or via a `AWS::IAM::Policy` resource. `AWS::IAM::ManagedPolicy` is for managed policies.

In terraform, [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) are managed policies and [aws_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) are inline policies.

## Inline policies

List names of inline policies

```
aws iam list-role-policies --role-name $(ROLE_NAME)
```

Get inline policy (cannot be used for managed policies)

```
aws iam get-role-policy --role-name $(ROLE_NAME) --policy-name $(POLICY_NAME)
```

Delete policy

```
aws iam delete-role-policy --role-name $(ROLE_NAME) --policy-name $(POLICY_NAME)
```

## Managed policies

List all managed policies

```
aws iam list-policies | jq -r '.Policies[].Arn' | sort
```

List managed policies attached to the role

```
aws iam list-attached-role-policies --role-name $(ROLE_NAME)
```

Get policy, which returns the default (ie: active) version

```
aws iam get-policy --policy-arn $(ARN)
```

Get managed policy document v1

```
aws iam get-policy-version --policy-arn $(ARN) --version-id v1 | jq .PolicyVersion.Document
```

List all policy versions

```
aws iam list-policy-versions --policy-arn $(ARN)
```

Create new managed policy

```
aws iam create-policy --policy-name my-policy --policy-document file:///tmp/policy.json
```

Update managed policy

```
aws iam create-policy-version --policy-arn $arn --policy-document file:///tmp/policy.json
```

Set default version of policy

```
aws iam set-default-policy-version --policy-arn $arn --version-id v1
```

Remove attached managed policy

```
aws iam detach-role-policy --role-name $rolename --policy-arn $arn
```

## Roles + Policy

Create [AWSBatchServiceRole](https://docs.aws.amazon.com/batch/latest/userguide/service_IAM_role.html):

```
aws iam create-role --role-name "AWSBatchServiceRole" --description "Allows Batch to create and manage AWS resources on your behalf." --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":["sts:AssumeRole"],"Principal":{"Service":["batch.amazonaws.com"]}}]}'

aws iam attach-role-policy --role-name "AWSBatchServiceRole" --policy-arn "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
```

List details of ec2InstanceRole (NB: make sure the policy version fetched is the default policy version and attached)

```
aws iam get-role --role-name ecsInstanceRole && aws iam list-attached-role-policies --role-name ecsInstanceRole && aws iam get-policy --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role && aws iam get-policy-version --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role --version-id v6
```

## Recreating roles

When a role is added to a resource policy a unique principal ID is generated. If the role is deleted and recreated, the resource policy will still contain the role but it will point to the old principal ID, which is no longer valid. This helps mitigate the risk of someone escalating their privileges by removing and recreating the role or user. Attempts to use the new role to access the resource will fail with an AccessDeniedException stating no resource-based policy allows the action. If you delete and recreate the role you'll need to edit the resource policy for it to generate a new principal ID.

The same holds for trust policies as described in the warning box [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html#principal-roles).

## Assuming roles

Assume role

```
aws sts assume-role --role-arn arn:aws:iam::123456789012:role/Developer --role-session-name doing-work --duration-seconds 3600
```

## Trusting root accounts

As an aside, I think even when granting access to specific IAM roles, we have to trust the IAM admins of the accounts those roles are in. This is because the IAM admins determine who or what can assume the role, so privilege escalation can always happen via unintended assumption. Granting access to the root account makes this more explicit. This is the argument made [here](https://ben11kehoe.medium.com/cross-account-role-trust-policies-should-trust-aws-accounts-not-roles-32737dfeaa03).

## Troubleshooting

> MalformedPolicyDocumentException: This resource policy contains an unsupported principal

Your policy contains a principal (eg: role arn) that does not exist. Check the role name and AWS account.

> MalformedPolicyDocument: The policy failed legacy parsing

Look for typos in arns or use of special characters, eg: `=`.

> MalformedPolicyDocument: Invalid principal in policy

Check the arn is correct including name and account.
