# aws sso

`aws configure sso` will create a profile in _~/.aws/config_ that uses SSO credentials, eg:

```
[profile my-dev-profile]
sso_start_url = https://my-sso-portal.awsapps.com/start
sso_region = us-east-1
sso_account_id = 123456789011
sso_role_name = readOnly
region = us-west-2
```

This profile can then be used by setting the `AWS_PROFILE` environment variable, or passing `--profile` to the AWS CLI.

When this profile is used it will look for SSO credentials (an OIDC access token) in _~/.aws/sso/cache/[hashed-profile-name].json_. If they don't exist or are expired boto will raise

```
botocore.exceptions.SSOTokenLoadError: Error loading SSO Token: The SSO access token has either expired or is otherwise invalid
```

To fetch a new access token run `aws sso login` which will pop up a browser page to perform the login.

There's a secondary cache in _~/.aws/cli/cache/[different-hashed-profile-name].json_ which contains cached STS credentials, generated using the OIDC access token. If these exist and are fresh they will be used, otherwise they will be regenerated using the OIDC access token.
