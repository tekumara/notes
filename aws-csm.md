# aws csm

Client side monitoring can be used to inspect AWS API calls.

Enable

```
export AWS_CSM_ENABLED=true
```

CSM will post api calls to localhost udp port 31000. To listen:

```
sudo tcpdump -i lo0 -n udp port 31000 -A
```

or

```
nc -luvp 31000
```

or watch with iamlive:

```
iamlive
```

## iamlive proxy mode

CSM does not record call parameters, so it's not possible to inspect things like the S3 bucket mode etc.

[iamlive](https://github.com/iann0036/iamlive) has a proxy mode that can record call params, eg:

Start iamalive

```
iamlive --mode proxy --sort-alphabetical
```

Enable

```
export HTTP_PROXY=http://127.0.0.1:10080
export HTTPS_PROXY=http://127.0.0.1:10080
export AWS_CA_BUNDLE=~/.iamlive/ca.pem
```

## References

- [Client Side Monitoring](https://summitroute.com/blog/2020/05/25/client_side_monitoring/)
- [Record AWS API calls to improve IAM Policies](https://cloudonaut.io/record-aws-api-calls-to-improve-iam-policies/)
- [iamlive](https://github.com/iann0036/iamlive) - Generate an IAM policy from AWS calls using client-side monitoring (CSM) or embedded proxy
