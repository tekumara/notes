# VPC

A VPC contains many subnets, and many security groups.

## Internet Gateway

You need an internet gateway (IGW) to be able to access resources in a VPC from the internet.
An IGW is attached to a VPC, and then subnets need to have routes to the IGW.

See [VPC - Internet Gateways](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html).

## NAT Gateway

A NAT gateway can forward traffic to the internet.

## Public IPs

Subnets may [auto-assign public IP addresses](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ip-addressing.html#vpc-public-ipv4-addresses).

You can still [launch instances with a public IP](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ip-addressing.html#vpc-public-ip) even if the subnet doesn't auto-assign them.

If you place a load-balancer or EC2 instance in a subnet without an IGW, even if public IP addresses are assigned it will not be accessible via the public IP addresses. See also [this tweet](https://twitter.com/nickpowpow/status/1490787348279267330?s=20&t=xK3yTLtx_plFWoIzzFuxqA).

### Elastic IPs

Elastic IPs are static public IPs. They can be assigned to one instance at a time, but can change instances.

See [Elastic IP addresses](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html)

## Hostnames

Instances that receive a public IP address are assigned an [external DNS hostname](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-instance-addressing.html#concepts-public-addresses), eg: `ec2-203-0-113-25.compute-1.amazonaws.com`

Instances with a private IP address are assigned an [internal DNS hostname](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-instance-addressing.html#concepts-private-addresses), eg: `ip-10-251-50-12.ec2.internal`

## Default VPC

IPv4 CIDR: 172.31.0.0/16  
Subnets: 172.31.0.0/20, 172.31.32.0/20, 172.31.32.0/20

The default VPC has an IGW and a default public subnet that will assign public IP addresses

See [Default VPC and default subnets](https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html).

## Describe

```
aws ec2 describe-vpcs --vpc-ids vpc-0654425a5c0c7bfe5
```

Describe stack id

```
aws ec2 describe-vpcs --vpc-ids vpc-02832796d9d01cfec | jq -r '.Vpcs[].Tags[] | select(.Key == "aws:cloudformation:stack-id") | .Value'
```

## VPC Endpoints

"Packets that originate from the AWS network with a destination on the AWS network stay on the AWS global network, except traffic to or from AWS China Regions....
In addition, all data flowing across the AWS global network that interconnects our data centers and Regions is automatically encrypted at the physical layer before it leaves our secured facilities."

see [VPC FAQS](https://aws.amazon.com/vpc/faqs/).

However internet data rates are still charged. VPC endpoints are charged differently. They are also useful for restricting what resources something in a VPC can communicate with, and restricting which VPCs can communicate with a resource. eg: you can restrict access to S3 buckets from the internet by denying access except from specific VPC endpoints. You can also add policies to endpoints, and you can restrict access to the Internet but allow access to VPC endpoints, see [Adopting AWS VPC Endpoints at Square](https://developer.squareup.com/blog/adopting-aws-vpc-endpoints-at-square/)
