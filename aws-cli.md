# aws cli

Install latest version on ubuntu:

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip -d /tmp/
sudo /tmp/aws/install
```

This creates _/usr/local/bin/aws_ and _/usr/local/aws-cli/_. AWS CLI 2 has its own built-in Python interpreter.

Install v1 on alpine:

```
apk add aws-cli
```

Install v2 on alpine:

```
# TODO
apk add gcompat curl

```

See [awscli version 2 on alpine linux](https://stackoverflow.com/questions/60298619/awscli-version-2-on-alpine-linux)

## Credentials file

To ignore the credentials file `export AWS_SHARED_CREDENTIALS_FILE=/dev/null` [ref](https://docs.aws.amazon.com/cli/latest/topic/config-vars.html)
