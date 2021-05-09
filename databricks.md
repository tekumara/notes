# Databricks

Notebooks with

- SQL, R, Python and Scala cells
- Spark UI
- publish
- comments
- integration with MLFlow
- git integration

Spark clusters with

- [Delta Lake and Delta Engine](https://docs.databricks.com/delta/index.html)
- Ganglia
- Spark UI
- [custom containers](https://docs.databricks.com/clusters/custom-containers.html)

[Jobs](https://docs.databricks.com/jobs.html)

- scheduled
- triggered

Plus

- table browser
- [analytics dashboards](https://twitter.com/dennylee/status/1367929072328667136?s=20)
- [sql analytics workspace](https://www.zdnet.com/article/databricks-launches-sql-analytics/)

## Architecture (AWS)

The databricks control plane lives in the Databricks AWS account, but via a [cross-account IAM role](https://docs.databricks.com/administration-guide/account-settings/aws-accounts.html) the control is able to create EC2 instances, and access them via a tunnel see [secure cluster connectivity](https://docs.databricks.com/security/secure-cluster-connectivity.html).

See [Databricks architecture overview](https://docs.databricks.com/getting-started/overview.html)

## Costs

AWS Instance costs + [DBU costs](https://databricks.com/product/aws-pricing/instance-types).

eg: m5.16xlarge 64 CPUs, 256GB per hour:

- AWS us-east-1 $3.072
- 10.96 DBU
  - Standard All-Purpose Compute: $4.38
  - Premium All-Purpose Compute: $6.03
  - Enterprise All-Purpose Compute: $7.12
