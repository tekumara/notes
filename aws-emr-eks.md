# aws emr on eks

Download [docker images](https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/docker-custom-images-tag.html):

```
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 895885662937.dkr.ecr.us-west-2.amazonaws.com
docker pull 895885662937.dkr.ecr.us-west-2.amazonaws.com/spark/emr-6.10.0:latest
```
