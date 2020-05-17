# Hadoop-AWS

This document describes relevant changes to Hadoop AWS functionality (in particular S3 functionality) across major versions.

For more info see [Hadoop-AWS module: Integration with Amazon Web Services](https://hadoop.apache.org/docs/r3.1.0/hadoop-aws/tools/hadoop-aws/index.html)

## Hadoop 2.8

The Hadoop [2.8 release line](http://hadoop.apache.org/docs/r2.8.0/index.html) contains S3A improvements to support any AWSCredentialsProvider which can then be used by Spark, eg:
```
-Dspark.hadoop.fs.s3a.aws.credentials.provider=org.apache.hadoop.fs.s3a.TemporaryAWSCredentialsProvider -Dspark.hadoop.fs.s3a.access.key=ASIAJUIDILRJ6RUYKJQA 
-Dspark.hadoop.fs.s3a.secret.key=xXATRSfqE0zg5miUuUgMBAkh5n2mZTOIMJ5pg+U6 
-Dspark.hadoop.fs.s3a.session.token=FQoDYXdzEDoaDN8pwbmIZ6ZbJ87AuCKiAj7FZRgUcl54zUJSZ7J5ipwxNc+9wH71h8RWYqbJ7gNf9cV3gX+dyv+VBavCZrnGFz0sG6NdBcbrfRGyPM5vcxKXYaP3Zn8+Z1zUpHyESodyPeSdLJFaXXVtfNb+MuEBvjuLF3okziKS56MYUNETJB5YQzEEAprC9Niz4m4Zb8MJ65kSqXnWMi3iodsdTbmb7Jay+h4PFrO3P3rKWP6ShDr1We0/BKmxyaeT3MhFFVxnTruaJPKqFnh99zYhn2+xFqgTlO7YnnIk9aQQMKNTkvYgSCD1tJRIDqeYzoxJ5TNntnEDTyVpeCJQGj5ZHIqhb2garUL8HqCHQ9PC0ApL5kPPE3Hg9O7YTUiyay4iPqWgfOxjBxYop/exQwVWt6rn7fQqKLfqodUF
```

S3A in Hadoop 2.8+ will also handle IAM auth in EC2 VM see [Authenticating with Amazon S3](https://hortonworks.github.io/hdp-aws/s3-security/)

NB: Access key, secret key, and session token can be found in `~/.aws/credentials` after a SAML/AssumeRole operation.

## Hadoop 2.9

The Hadoop [2.9 release line](http://hadoop.apache.org/docs/r2.9.0/index.html) contains [S3Guard](http://hadoop.apache.org/docs/r2.9.0/hadoop-aws/tools/hadoop-aws/s3guard.html) which provides consistency and metadata caching for S3A via a backing DynamoDB metadata store.

Also contains [HADOOP-14596](https://issues.apache.org/jira/browse/HADOOP-14596) which prevents the following warning appearing in the shell:
```WARN S3AbortableInputStream: Not all bytes were read from the S3ObjectInputStream, aborting HTTP connection```


## Hadoop 3.1

The Hadoop [3.1 release line](http://hadoop.apache.org/docs/r3.1.0/index.html) incorporates HADOOP-13786 which contains optimised job committers including the Netflix staging committers (Directory and Partitioned) and the Magic committers. See [committers](https://github.com/apache/hadoop/blob/branch-3.1/hadoop-tools/hadoop-aws/src/site/markdown/tools/hadoop-aws/committers.md) and [committer architecture](https://github.com/apache/hadoop/blob/trunk/hadoop-tools/hadoop-aws/src/site/markdown/tools/hadoop-aws/committer_architecture.md)


S3A metrics can now be monitored through Hadoop's metrics2 framework, see [Metrics](https://hadoop.apache.org/docs/r3.1.0/hadoop-aws/tools/hadoop-aws/index.html#Metrics). The is configured via `hadoop-metrics2.properties`. If this file is missing the following warning will appear once in spark shell:
```WARN MetricsConfig: Cannot locate configuration: tried hadoop-metrics2-s3a-file-system.properties,hadoop-metrics2.properties```

 