# research environments

|                        | EC2 Home-grown                  | JupyterHub k8s           | Determined k8s         | SageMaker              |
| ---------------------- | ------------------------------- | ------------------------ | ---------------------- | ---------------------- |
| Custom setup           | Scripts/Packer for AMI          | Docker container         | Docker container       |                        |
| SSH                    | Keypair + Security Group/SSM    | N/A (terminal instead)   | N/A (terminal instead) |                        |
| HTTP port access       | Security Group/ssh port-forward | jupyter-server-proxy     | ?                      |                        |
| Service discovery      | None                            | Stable hostname          | Stable hostname        |                        |
| Authentication         | AWS Auth                        | OAuth                    | Password               | AWS Auth               |
| Persistent storage     | EBS                             | PVC                      | PVC                    |                        |
| RBAC to AWS resources  | EC2 Instance profile            | KIAM/OIDC                | ?                      |                        |
| Audit                  | SSM login, AWS resources        | Login, AWS resources     | ?                      | ?                      |
| Git integration        | script key/token install        | nbgitpuller read, write? | ?                      | One repo, one instance |
| Spark/Livy integration | EMR - VPC/Security Group        | ?                        | ?                      | ?                      |
