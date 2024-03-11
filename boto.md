# boto

[Resource vs Client](https://stackoverflow.com/questions/42809096/difference-in-boto3-between-resource-client-and-session)

[Low-level clients](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/clients.html).

Both clients and resources have waiters.

## Region

A region can be specified when creating a client. If none is specified the lookup order is:

1. `AWS_DEFAULT_REGION` [environment variable](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)
1. _~/.aws/config_ file, for the profile specified (or default profile)
1. Raise a NoRegionError

NB: See [AWS Region](https://docs.aws.amazon.com/sdkref/latest/guide/feature-region.html) for more info on which clients use which env vars. aws-cli and boto use `AWS_DEFAULT_REGION`

## Use STS credentials created by the AWS CLI

The following will use STS credentials created by the AWS CLI, if they exist.

```python

# Create boto3 client from session
client = boto3.Session(botocore_session=session).client('ec2')


def get_caching_session(profile_name=None):
    """Construct botocore session using cached STS creds if any

    Stolen from: https://github.com/mixja/boto3-session-cache
    """
    logger.info("Reading AWS credentials")

    try:
        sess = botocore.session.get_session()
    except botocore.exceptions.PartialCredentialsError:
        logger.error("Credentials are not complete. "
                     "Maybe use --profile or set AWS_PROFILE")
        raise

    if profile_name:
        sess.set_config_variable("profile", profile_name)

    # read cached STS creds
    cli_cache = os.path.join(os.path.expanduser("~"), ".aws/cli/cache")

    sess.get_component("credential_provider").get_provider(
        "assume-role"
    ).cache = credentials.JSONFileCache(cli_cache)

    return sess
```

See also [Boto3 Docs / Developer guide / Credentials](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html)

## Config vs credentials

[Curious about the differences between ~/.aws/credentials and ~/.aws/config?🧵](https://twitter.com/jsaryer/status/1294365822819999744)

## Logging

Be careful enabling the debug loglevel on `botocore` as `botocore.endpoint` will log requests and `botocore.parsers` will log the response which may contain sensitive info.

To log retries and connections:

```
logging.getLogger("botocore.retryhandler").setLevel(logging.DEBUG)
logging.getLogger("urllib3.connectionpool").setLevel(logging.DEBUG)
```
