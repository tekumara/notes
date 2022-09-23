# minio

Run in docker serving from _/data_ within in the image:

```
docker run -p 9000:9000 -p 9001:9001 minio/minio server /data --console-address :9001
```

The [default root user/pass](https://docs.min.io/minio/baremetal/security/minio-identity-management/user-management.html#minio-root-user) is: `minioadmin/minioadmin`

Create a bucket using the aws cli

```
AWS_ACCESS_KEY_ID=minioadmin AWS_SECRET_ACCESS_KEY=minioadmin aws --endpoint-url http://localhost:9000 s3 mb s3://minio-flows
```

## client

Install client

```
brew install minio/stable/mc
```

Config client to talk to localhost

```
mc config host add local http://localhost:9000 minioadmin minioadmin
```

Info

```
mc admin info local
```

List buckets

```
mc ls local
```

Create bucket called mybucket

```
mc mb local/mybucket
```
