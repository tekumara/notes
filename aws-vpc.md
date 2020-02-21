# VPC

A VPC contains many subnets, and many security groups. Subnets may 

## Internet Gateway

You need an internet gateway (IGW) to be able to access resources in a VPC from the internet.
An IGW is attached to a VPC, and then subnets need to have routes to the IGW.

https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html

## NAT Gateway

A NAT gateway can forward traffic to the internet.

## Subnets

Subnets may [auto-assign public IP addresses](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ip-addressing.html#vpc-public-ipv4-addresses).

You can still [launch instances with a public IP](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ip-addressing.html#vpc-public-ip) even if the subnet doesn't auto-assign them.

If you place a load-balancer or EC2 instance in a subnet without an IGW, even if public IP addresses are assigned it will not be accessible via the public IP addresses.

## Default VPC

IPv4 CIDR: 172.31.0.0/16
Subnets: 172.31.0.0/20, 172.31.32.0/20, 172.31.32.0/20

The default VPC has an IGW and a default public subnet that will assign public IP addresses

https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html


## Describe

```
aws ec2 describe-vpcs --vpc-ids vpc-0654425a5c0c7bfe5
```

Describe stack id
```
aws ec2 describe-vpcs --vpc-ids vpc-02832796d9d01cfec | jq -r '.Vpcs[].Tags[] | select(.Key == "aws:cloudformation:stack-id") | .Value'
```