# terraform provider helm

## Auth

The `aws_eks_cluster_auth` data source generates a 15 min token which is a [signed STS GetCallerIdentityRequest](https://github.com/hashicorp/terraform-provider-aws/blob/196cfd3/internal/service/eks/token.go#L196).

This can be passed as the [`token` param](https://github.com/hashicorp/terraform-provider-helm/blob/ff039c3efa656b621c52b0b1fc9e8235305f43b3/helm/structure_kubeconfig.go#L159) to the helm provider:

```
provider "helm" {
  kubernetes {
    host                   = "https://${data.dns_cname_record_set.paas.cname}"
    cluster_ca_certificate = data.http.ca.body
    token                  = data.aws_eks_cluster_auth.paas.token
  }
}
```

## Troubleshooting

### Kubernetes cluster unreachable: the server has asked for the client to provide credentials

You don't have the right credentials for calling the Kube API.

If you are using the `aws_eks_cluster_auth` data source to generate a token, make sure the AWS provider is using a role that has [access](aws-eks-auth.md) to the cluster. Also make be aware that the data source [generates a short-lived 15 - 1 min token](https://github.com/hashicorp/terraform-provider-aws/blob/196cfd3/internal/service/eks/token.go#L193) at plan time, which may have expired by apply time. An alternative is to [use exec instead](https://github.com/hashicorp/terraform-provider-helm/issues/893#issuecomment-1171455299).
