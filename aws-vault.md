# aws-vault

[aws-vault](https://github.com/99designs/aws-vault) stores AWS creds (includes GetSessionToken MFA creds) securely in the OS keychain, which it then uses to generate STS creds.

`aws-vault exec` and `aws-vault login` will fetch an STS session token on each invocation. By default the session token lasts for 15 mins. When it expires you'll need to rerun `aws-vault exec`. You can extend this with the `--assume-role-ttl` flag or the `AWS_ASSUME_ROLE_TTL` environment variable, eg: `export AWS_ASSUME_ROLE_TTL=1h`.

By default the aws-vault MFA session lasts for 4 hours. When it expires you'll need re-enter your MFA code.

`aws-vault login` uses a federation token to login to the web console. A federation token is a typically longer-lived, and older style of token. You can only log into one account at a time. Logging in to a second account will log you out of the first.

{"AccessKeyID":"AKIAW6H6UZACACVMOXNR","SecretAccessKey":"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","SessionToken":"","ProviderName":""}

By default aws-vault will use stdin/stdout for the MFA token prompt. Use `--prompt=osascript` to show a macOS window prompt instead.

To store your default profile access key in the aws-vault keychain:

```
aws-vault add default
```

To delete existing creds (eg: when the access key expires)

```
aws-vault remove default
```

To assume a role

```
aws-vault exec role -- aws sts get-caller-identity
```

To use [session tags](https://github.com/99designs/aws-vault/blob/db08b16d1c08c370e0f20616710ea11b5b24c9fc/USAGE.md#session_tags-and-transitive_session_tags) when assuming a role add them to AWS config:

```
[profile order-dev]
source_profile = root
role_arn=arn:aws:iam::123456789:role/developers
session_tags = key1=value1,key2=value2,key3=value3
transitive_session_tags = key1,key2
```

To specify the [role session name](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_iam-condition-keys.html#ck_rolesessionname), use env var `AWS_ROLE_SESSION_NAME` or add it to the AWS config:

```
[profile order-dev]
source_profile = root
role_arn=arn:aws:iam::123456789:role/developers
session_tags = key1=value1,key2=value2,key3=value3
role_session_name = alice@developers.com
```

To extract and set env vars in the current shell

```
aws_vault_export() {
   aws-vault exec $1 -- env | grep AWS | sed -e 's/^/export\ /'
}
```

Then `eval "$(aws_vault_export profile1)"` ([ref](https://github.com/99designs/aws-vault/issues/72#issuecomment-234908710)).

aws-vault can also be used as a [credential process](https://github.com/99designs/aws-vault/blob/db08b16d1c08c370e0f20616710ea11b5b24c9fc/USAGE.md#using-credential_process). This inverts the call stack so that aws-cli calls aws-vault when it needs credentials rather than setting them first using aws-vault.

By default the macOS keychain password prompt will appear after 5 minutes of inactivity. This can be [changed](https://github.com/99designs/aws-vault/blob/master/USAGE.md#keychain).
