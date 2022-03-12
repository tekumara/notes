# terraform provider helm

## Troubleshooting

### Kubernetes cluster unreachable: the server has asked for the client to provide credentials

You don't have the right credentials for calling the Kube API.

If you are using the `aws_eks_cluster_auth` data source to generate a token, make sure the AWS provider is using a role that has [access](aws-eks-auth.md) to the cluster.
