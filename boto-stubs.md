# boto-stubs

[boto3-stubs](https://pypi.org/project/boto3-stubs/) are built by [mypy_boto3_builder](https://github.com/vemel/mypy_boto3_builder).

Install stubs per service, eg: for ec2

```
pip install boto3-stubs[ec2]
```

This will install the following packages:

- boto3-stubs - [these files](https://github.com/vemel/mypy_boto3_builder/tree/master/mypy_boto3_builder/boto3_stubs_static)
- boto3
- [mypy_boto3](https://pypi.org/project/mypy-boto3/) - dynamically generates boto3.client/boto3.resource stubs
- [mypy_boto3_ec2](https://pypi.org/project/mypy-boto3-ec2/)

## Explicit type hints

Import the type stubs to use them as explicit type hints:

```python
import boto3
from mypy_boto3_ec2 import Client

ec2_client:Client = boto3.client("ec2")

print(ec2_client.describe_instances())
```

If you store the boto3 client or resource in a variable, or return it from a function, you'll probably want to use the explicit type hints:

```python
from mypy_boto3_ec2 import ServiceResource


resource: ServiceResource = resource()


def resource() -> ServiceResource:
    return boto3.resource("ec2")
```

The disadvantage of using explicit type hints is it requires shipping the boto3-stubs package with your application.

## Use mypy_boto3 to generate boto3.client/boto3.resource stubs for implicit usage

Given `boto3-stubs[ec2]` is installed, then:

```
python -m mypy_boto3
```

Will generate the `mypy_boto3.ec2` package containing [client, service etc modules](https://pypi.org/project/mypy-boto3/#Generated-files). This package in turn imports from `mypy_boto3_ec2`.

The generated modules enable usage of `boto3.client` and `boto3.resource` without explicit type hints:

```python
import boto3

ec2_client = boto3.client("ec2")

print(ec2_client.describe_instances())
```

The advantage of implicit type hints is you don't need to import `mypy_boto3_ec2` and therefore ship it with your application.

## Reference

See also [mypy_boto3/#4](https://github.com/vemel/mypy_boto3/issues/4#issuecomment-562957482)
