# AWS SageMaker Notebook instances

SageMaker Notebook instances provide authenticated browser based access to a Jupyter environment running on an EC2 instance managed by AWS.

Features:

- CPU and GPU instance types, with support for [elastic inference](https://docs.aws.amazon.com/sagemaker/latest/dg/ei.html), at a 25-30% premium to EC2
- Simplified console management of notebook instances
- Authenticated pre-signed URLs for browser based access
- Slower than EC2 to start
- Multiple git repositories can be cloned on startup into the environment using user-supplied credentials stored in AWS Secrets Manager.
- Lifecycle configurations which customize the environment on creation or startup.
- An AWS managed image based on Amazon Linux AMI 2018.03
- User EBS volumes of configurable size
- An environment configured for building and running Docker containers
- An older v1 version of JupyterLab
- Multiple pre-configured conda environments
- Jupyter logs shipped to CloudWatch
- Internet and VPC egress (configurable)

## API Usage

List instances and their status

```
aws sagemaker list-notebook-instances | jq -r '.NotebookInstances[] | [.NotebookInstanceName,.NotebookInstanceStatus] | @tsv' | column -t -s $'\t'
```

## More Details

[Git repos](https://docs.aws.amazon.com/sagemaker/latest/dg/nbi-git-resource.html) are added per AWS account and accessed using a username and password stored in AWS Secrets Manager. Multiple repos can be associated. There are cloned under _/home/ec2-user/SageMaker_ and can be used by the jupyterlab-git extension, see [Use Git Repositories in a Notebook Instance](https://github.com/awsdocs/amazon-sagemaker-developer-guide/blob/master/doc_source/git-nbi-use.md).

## Access

Notebook instances accessed via a presigned domain url, eg: `https://<notebook_name>.notebook.<region>.sagemaker.aws`

Ports (eg: TensorBoard etc.) on the notebook instance can be accessed via `https://<notebook_name>.notebook.<region>.sagemaker.aws/proxy/<port>`. This is enabled by [nbserverproxy](https://github.com/tekumara/sagemaker/tree/main/nbserverproxy).

Notebook instances also run the amazon SSM agent.

## Volumes

User volumes are mounted at /home/ec2-user/SageMaker

```
$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  110G  0 disk
└─xvda1 202:1    0  110G  0 part /
xvdf    202:80   0    5G  0 disk /home/ec2-user/SageMaker
```

The jupyter lab notebook dir (aka root dir) is /home/ec2-user/SageMaker

## Customization

The base image (mounted at /) is Amazon Linux AMI 2018.03 and managed by AWS. Outside of _/home/ec2-user/SageMaker_ any modifications to the filesystem will not persist after shutdown.

[Lifecycle configurations](https://docs.aws.amazon.com/sagemaker/latest/dg/notebook-lifecycle-config.html) can be used to run a script when a notebook is started or created. See [these examples](https://github.com/aws-samples/amazon-sagemaker-notebook-instance-lifecycle-config-samples) eg: [stopping notebook instances that are idle](https://github.com/aws-samples/amazon-sagemaker-notebook-instance-lifecycle-config-samples/tree/master/scripts/auto-stop-idle)

## IAM

EC2 metadata

```
$ curl -s http://169.254.169.254/latest/meta-data/iam/info | jq -r .InstanceProfileArn

arn:aws:iam::764707924415:instance-profile/BaseNotebookInstanceEc2InstanceRole
```

However for any AWS API calls the execution role is assumed, eg: `arn:aws:iam::{your-aws-account}:role/service-role/AmazonSageMaker-ExecutionRole-20190131T145746`.

## Network

SageMaker notebook instances (with or without VPC access) run in an Amazon managed account (764707924415) and don't appear as EC2 instances in the AWS console.

For any VPC access, a Network Interface (ENI) is created in the VPC and attached to the notebook instance.

## Jupyter

Jupyter started with

```
/home/ec2-user/anaconda3/envs/JupyterSystemEnv/bin/python /home/ec2-user/anaconda3/envs/JupyterSystemEnv/bin/jupyter-notebook --notebook-dir=/home/ec2-user/SageMaker/ --ip=0.0.0.0 --NotebookApp.token= --port=8443 --NotebookApp.disable_check_xsrf=True --certfile=/home/ec2-user/.jupyter/notebookcert.pem --keyfile /home/ec2-user/.jupyter/notebookkey.key
```

JupyterLab version 1.2.18 (as of Oct 2020).

The kernel spec manager class is `nb_conda_kernels.CondaKernelSpecManager`.

Config file: _~/.jupyter/jupyter_notebook_config.py_

## Conda envs

```
$ ls /home/ec2-user/anaconda3/envs/JupyterSystemEnv
amazonei_mxnet_p27 amazonei_tensorflow2_p36 chainer_p27 mxnet_latest_p37 python2 pytorch_p27 tensorflow2_p36
amazonei_mxnet_p36 amazonei_tensorflow_p27 chainer_p36 mxnet_p27 python3 pytorch_p36 tensorflow_p27
amazonei_tensorflow2_p27 amazonei_tensorflow_p36 JupyterSystemEnv mxnet_p36 pytorch_latest_p36 R tensorflow_p36
```

## Jupyterlab extensions

- @jupyterlab/celltags v0.2.0 enabled OK
- @jupyterlab/git v0.11.0 enabled OK
- @jupyterlab/toc v2.0.0 enabled OK
- nbdime-jupyterlab v1.0.0 enabled OK
- sagemaker_examples v0.1.0 enabled OK
- sagemaker_session_manager v0.1.0 enabled OK

## jupyter server extensions

- jupyterlab_git 0.11.0
- jupyterlab 1.2.18
- nbdime 1.1.0
- nb_conda 2.2.1
- sparkmagic 0.16.0
- nbserverproxy
- nbexamples.handlers
- sagemaker_nbi_agent

## References

[SageMaker Workshop - Building Secure Environments](https://sagemaker-workshop.com/security_for_sysops.html)
