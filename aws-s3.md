# aws s3

## boto

List objects in bucket:

```python
from boto3 import client
conn = client('s3')
for key in conn.list_objects(Bucket='xero-data-apps-prod-xos-sandbox-flows')['Contents']:
    print(key['Key'])
```

## Regions

S3 bucket names must be globally unique across all regions and accounts. The S3 console will show a global list of buckets across all regions for the account, but each bucket is actually stored in only a single region which you need to specify when creating a bucket.

List all buckets in an account across all regions:

```
aws s3api list-buckets | jq -r '.Buckets[] | .Name'
```

Show a bucket's region:

```
aws s3api get-bucket-location --bucket $BUCKET
```

## Limits and Prefixes

Each prefix (shard) is limited to 5500 rps. Prefixes used to be determined by the start of the object name, now they are automatic which means you don't need to deliberately name your objects with distinct prefixes. Prefixes will split and merge behind the scenes in response to actual load. Contact Amazon and they can tell you how many prefixes your bucket as. For rare reads, the TTFB might be slow.

## Metadata

Bucket tags:

```
aws s3api get-bucket-tagging --bucket dt-apps-terraform-state-ps-paas-test | jq -r '.TagSet[] | [.Key, .Value] | @tsv' | column -t
```

Object metadata (will be written to stdout):

```
aws s3api get-object --bucket BUCKET --key KEY --version-id VERSION outfile
```

## Multiple versions

List versions

```
aws s3api list-object-versions --bucket my-bucket --prefix index.html
```

Get specific version

```
aws s3api get-object --bucket BUCKET --key KEY --version-id VERSION outfile
```

## Permissions & Ownership

Get the display name and canonical user id for an account

```
aws s3api list-buckets | jq '.Owner'
```

Get an object ACL, including the owner

```
aws s3api get-object-acl --bucket BUCKET --key KEY
```

If you get Access Denied then you don't have read object permissions. You may still be able to view the owner via the AWS web console (but not details of server side encryption - it will say `Access denied`). This can happen if a user in another account has uploaded an object to your bucket without giving the bucker owner permissions. You'll be able to list the object but not read it or see its permissions. See this [Stack Overflow question](https://stackoverflow.com/questions/34055084/s3-user-cannot-access-object-in-his-own-s3-bucket-if-created-by-another-user)

Grant the bucket owner full control (do this from the account that created the object)

```
aws s3api put-object-acl --acl bucket-owner-full-control --bucket BUCKET --key KEY
```

Remove encryption, and grant the bucket owner full control:

```
aws s3 cp --acl bucket-owner-full-control s3://bucket/key s3://bucket/key
```

Remove encryption on every object in a bucket, and grant the bucket owner full control:

```
aws s3 cp --acl bucket-owner-full-control --recursive s3://bucket/ s3://bucket/ --storage-class STANDARD
```

## Encryption

Default encryption will be applied to any subsequent PUT requests without encryption, and won't change the encryption status of existing objects.

Get bucket level default encryption:

```
aws s3api get-bucket-encryption --bucket $bucket
```

Set bucket level default encryption with a KMS key:

```
aws s3api put-bucket-encryption --bucket $bucket --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "aws:kms","KMSMasterKeyID":"arn:aws:kms:us-east-1:1234567890:alias/top-secret-key"}}]}'
```

Get object level encryption

```
aws s3api head-object --bucket BUCKET --key KEY
{
    "AcceptRanges": "bytes",
    "ContentType": "binary/octet-stream",
    "LastModified": "Sun, 20 May 2018 18:28:29 GMT",
    "ContentLength": 1155998,
    "ETag": "\"00f29266fe0c9bc6a833b1f629d65ba7\"",
    "ServerSideEncryption": "aws:kms",
    "SSEKMSKeyId": "arn:aws:kms:ap-southeast-2:12345678:key/abcd1234-df76-4e4a-aaab-7344676d6",
    "Metadata": {}
}
```

ServerSideEncryption options:

- `AES256` = Amazon S3-managed keys (SSE-S3)
- `aws:kms` = AWS Key Management Service key (SSE-KMS)

If your role doesn't have KMS privileges, GetObject and PutObject calls will fail with AccessDenied. Add the following policy to your role:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "arn:aws:kms:ap-southeast-2:12345678:key/abcd1234-df76-4e4a-aaab-7344676d6"
        }
    ]
}
```

Get the bucket policy

```
aws s3api get-bucket-policy --bucket $bucket --query Policy --output text | jq .
```

## Objects created by another account

Objects created by another account aren't accessible to the owning account.

By default transitive rights to objects created by other accounts, in a bucket you owned, can't be granted to third account. Instead use roles, see [Example 4: Bucket owner granting cross-account permission to objects it does not own](https://docs.aws.amazon.com/AmazonS3/latest/dev/example-walkthroughs-managing-access-example4.html#access-policies-walkthrough-example4-step3).

### Amazon S3 Object Ownership

[Amazon S3 Object Ownership](https://aws.amazon.com/about-aws/whats-new/2020/10/amazon-s3-object-ownership-enables-bucket-owners-to-automatically-assume-ownership-of-objects-uploaded-to-their-buckets/) allows bucket owners to automatically assume ownership when an object is created with the `bucket-owner-full-control` canned ACL.

To create an object with the canned ACL:

```python
bucket.put_object(
    ACL='bucket-owner-full-control',
    Key=key,
    Body=data.encode('utf-8')
)
```

or

```
aws s3 cp file.txt s3://DOC-EXAMPLE-BUCKET --acl bucket-owner-full-control
```

## Missing objects

If you don't have `s3:ListBucket` permissions the trying to access a missing object will return a 403 Access Denied.
In order to receive a 404 Not Found, grant `s3:ListBucket` to the bucket (note: not the objects!), eg:

```
            - Effect: Allow
              Action:
                - s3:ListBucket
              Resource:
                - arn:aws:s3:::my-bucket
```

See [How do I troubleshoot 403 Access Denied errors from Amazon S3?](https://aws.amazon.com/premiumsupport/knowledge-center/s3-troubleshoot-403/)

## Server access logging

Log all access attempts to S3 with their IP address. You pay for the S3 storage fees for the log files.

> Amazon S3 uses a special log delivery account, called the Log Delivery group, to write access logs. These writes are subject to the usual access control restrictions. You must grant the Log Delivery group write permission on the target bucket by adding a grant entry in the bucket's access control list (ACL). If you use the Amazon S3 console to enable logging on a bucket, the console both enables logging on the source bucket and updates the ACL on the target bucket to grant write permission to the Log Delivery group.

eg: object _2018-07-04-04-29-24-42BE2810684123A8_:

```
a70b8bf27f12d16678031c31cb9c485edc3404af6d850ea0ce414ed11f7a7c4e my-amazing-bucket [03/Jul/2018:06:47:25 +0000] 120.130.116.3 arn:aws:sts::123456789012:assumed-role/Developer F46FB89A472A0A21 REST.GET.LOCATION - "GET /my-amazing-bucket?location HTTP/1.1" 200 - 142 - 53 - "-" "CloudCustodian/0.8.28.2 Python/2.7.12 Linux/4.9.93-41.60.amzn1.x86_64 exec-env/AWS_Lambda_python2.7 Botocore/1.10.35" -
```

## Object-level logging

Log data events (eg: GetObject and PutObject) to CloudTrail. \$0.10 per 100,000 events + S3 bucket costs. Includes the IAM principal if it exists. In addition you can then create Cloudwatch rules, trigger alerts/lambdas etc. They don't contain IP addresses:

```
{"requestID": "E88A8280F1A9D9F9", "responseElements": null, "sharedEventID": "4f20382f-7c5a-4b50-8092-3d6b65e42921", "recipientAccountId": "123456789012", "readOnly": false, "additionalEventData": {"x-amz-id-2": "QAyufnNHbCgGd5A7XnQfK43BseLBD4p16pZGOAoI2xyaEbYoJycfep0H2SXldFRcTywS+H4hZ1k="}, "userAgent": "s3.amazonaws.com", "eventTime": "2018-07-04T04:29:24Z", "resources": [{"type": "AWS::S3::Object", "ARN": "arn:aws:s3:::my-amazing-bucket/s3-logs-my-amazing-bucket2018-07-04-04-29-24-42BE2810684123A8"}, {"type": "AWS::S3::Bucket", "accountId": "123456789012", "ARN": "arn:aws:s3:::my-amazing-bucket"}], "eventName": "PutObject", "eventType": "AwsApiCall", "requestParameters": {"bucketName": "my-amazing-bucket", "key": "s3-logs-my-amazing-bucket2018-07-04-04-29-24-42BE2810684123A8", "accessControlList": {"x-amz-grant-full-control": "id=\"3272ee65a908a7677109fedda345db8d9554ba26398b2ca10581de88777e2b61\", id=\"a70b8bf27f12d16678031c31cb9c485edc3404af6d850ea0ce414ed11f7a7c4e\""}}, "eventVersion": "1.05", "eventID": "8b7b0930-f689-40f1-905b-c09bad9a4f8a", "awsRegion": "ap-southeast-2", "eventSource": "s3.amazonaws.com", "sourceIPAddress": "s3.amazonaws.com", "userIdentity": {"type": "AWSService", "invokedBy": "s3.amazonaws.com"}}
```

See also: [https://docs.aws.amazon.com/AmazonS3/latest/userguide/logging-with-S3.html](Logging options for Amazon S3)

## Rename

```
aws s3 ls --summarize --human-readable --recursive s3://my-amazing-bucket/ > my-amazing-bucket.ls
grep test3 my-amazing-bucket.ls > my-amazing-bucket-test3.ls
cat my-amazing-bucket-test3.ls | tr -s ' ' | cut -f5 -d' ' > my-amazing-bucket-test3.current
sed 's|adhoc/test3|prehistorical|;s|201510-11|201510|;s|201511-12|201511|' my-amazing-bucket-test3.current > my-amazing-bucket-test3.new
paste -d, my-amazing-bucket-test3.current my-amazing-bucket-test3.new
paste -d, my-amazing-bucket-test3.current my-amazing-bucket-test3.new > my-amazing-bucket-test3.mv
time parallel -a my-amazing-bucket-test3.mv --colsep ',' aws s3 mv "s3://my-amazing-bucket/{1}" "s3://my-amazing-bucket/{2}" --dryrun  | tee my-amazing-bucket-test3.mv.out
```

## Copy everything with a prefix

If the prefix ends in `/` it will copy everything with that prefix

```
aws s3 cp --recursive s3://bucket/cool-things/ .
```

However, this won't work for things without the slash, where as ls will

```
# will list all objects prefixed with cool-things/jan
aws s3 ls --recursive s3://bucket/cool-things/jan

# won't copy anything
aws s3 ls --recursive s3://bucket/cool-things/jan

# use exclude include instead eg
aws s3 ls --recursive --exclude "*" --include "jan*" s3://bucket/cool-things/
```

## Sync

To improve the perf of a sync:

```
aws configure set default.s3.max_concurrent_requests 1000
aws configure set default.s3.max_queue_size 100000
```

Should achieve about 700 MiB/s on a m5.large.

## Downloading from the console

For private buckets the object URL will return "AccessDenied". Use the download button instead.

## Creating a bucket

To create a bucket and block all public access:

```
bucket=delete-me-please
aws s3 mb s3://$bucket
aws s3api put-public-access-block --bucket $bucket --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

S3 buckets names must be globally unique. If you use boto to try to create a bucket that already exists, but in a different region, you'll get the cryptic error message:

```
botocore.exceptions.ClientError: An error occurred (IllegalLocationConstraintException) when calling the CreateBucket operation: The unspecified location constraint is incompatible for the region specific endpoint this request was sent to.
```

([ref](https://github.com/aws/aws-cli/issues/2603#issuecomment-428220985))

## Delete a bucket

```
# delete all objects in a bucket and the bucket itself
aws s3 rb --force "s3://$bucket"
```

## Deny access using a bucket policy

This will take precedence over an IAM policy:

```
{
    "Version": "2012-10-17",
    "Id": "Policy1619743014342",
    "Statement": [
        {
            "Sid": "Stmt1619743011846",
            "Effect": "Deny",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::123456789012:role/AwesomeRole1",
                    "arn:aws:iam::123456789012:role/AwesomeRole2"
                ]
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::awesome-bucket/*"
        }
    ]
}
```

To block all access:

```
BUCKET=awesome-bucket && aws s3api put-bucket-policy --bucket $BUCKET --policy '{
    "Version": "2012-10-17",
    "Id": "Policy1619743014342",
    "Statement": [
        {
            "Sid": "Stmt1619743011846",
            "Effect": "Deny",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::'"$BUCKET"'/*"
        }
    ]
}'
```

## Access a public bucket without credentials

eg:

```
aws s3 ls --recursive --summarize --human-readable s3://ai2-public-datasets/ --no-sign-request
```

## S3 Bucket Keys

S3 bucket keys can bypass KMS IAM perms, eg: changes to the source KMS key policy may not be immediately propagated to the bucket key which is a copy of the KMS key.

## Folders

From the console you can create a folder, which [creates an empty object](https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-folders.html#create-folder) with the name of the folder eg: `myfolder/`
