# AMIs

## [Deep Learning Base OSS Nvidia Driver GPU AMI (Ubuntu 22.04) 20250505](https://aws.amazon.com/releasenotes/aws-deep-learning-base-gpu-ami-ubuntu-22-04/)

ami-0bbdd5918468148eb Deep Learning Base OSS Nvidia Driver GPU AMI (Ubuntu 22.04) 20250505

```
AMI Name: Deep Learning Base OSS Nvidia Driver GPU AMI (Ubuntu 22.04)
Supported EC2 instances: G4dn, G5, G6, Gr6, G6e, P4d, P4de, P5, P5e, P5en
NVIDIA driver version: 570.133.20
CUDA versions available: cuda-12.4 cuda-12.5 cuda-12.6 cuda-12.8
Default CUDA version is 12.8
```

```
ubuntu@ip-10-97-37-2:~$ df -h
Filesystem       Size  Used Avail Use% Mounted on
/dev/root         73G   50G   24G  68% /
tmpfs            7.8G     0  7.8G   0% /dev/shm
tmpfs            3.1G  896K  3.1G   1% /run
tmpfs            5.0M     0  5.0M   0% /run/lock
efivarfs         128K  3.8K  120K   4% /sys/firmware/efi/efivars
/dev/nvme0n1p15  105M  6.1M   99M   6% /boot/efi
tmpfs            1.6G  4.0K  1.6G   1% /run/user/1000
```

## [Deep Learning Base AMI (Ubuntu 18.04) Version 31.0](https://aws.amazon.com/marketplace/pp/B077GCZ4GR)

- us-east-1 ami-063f381b07ea97834
- supports c, m, p2 & p3
- Nvidia driver version: 450.80.02
- CUDA versions available: cuda-10.0 cuda-10.1 cuda-10.2 cuda-11.0
- Default CUDA version is 10.0 (ie: the _/usr/local/cuda_ symlink)
- Libraries: cuDNN, NCCL, Intel MKL-DNN
- Docker version 19.03.13, Nvidia Container Toolkit v1.3.0
- [Elastic Fabric Adapter (EFA)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa.html) network device, can be used on [supported instance types](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa.html#efa-instance-types)
- Python 3.6.9
- [GPU monitoring in cloudwatch](https://aws.amazon.com/blogs/machine-learning/monitoring-gpu-utilization-with-amazon-cloudwatch/) installed in \_~/tools/GPUCloudWatchMonitor/gpumon.py
- SSM agent

For more info see the [release notes](https://aws.amazon.com/releasenotes/aws-deep-learning-base-ami-ubuntu-18-04-version-31-0/)

## [Deep Learning AMI (Ubuntu) v12.0](https://aws.amazon.com/marketplace/pp/B077GCH38C)

- us-east-1 ami-d1c9cdae
- supports c, m, p2 & p3
- CUDA 8.0, 9.0, 9.1, 9.2 and cuDNN 7.1.4, and NVidia Driver 396.37.
- Python 3.6.4 :: Anaconda Inc (/home/ubuntu/anaconda3/bin/python3)
- Ubuntu 16.04.4 LTS (GNU/Linux 4.4.0-1060-aws x86_64v)
- 60g disk in use
- Conda environment with Tensorflow 1.9.0 + (+Intel MKL-DNN) + Horovod.
- On conda activatation, will install an optimised tensorflow CPU (ie: that uses AVX2 AVX512F FMA instructions) or GPU version based on the instance type - see `/home/ubuntu/anaconda3/envs/tensorflow_p36/etc/conda/activate.d/99_install_tf.sh`.

### Conda environments

```
$ cat /home/ubuntu/anaconda3/envs/tensorflow_p36/etc/conda/activate.d/00_activate.sh
#!/bin/sh
export ENV_NAME=tensorflow_p36
export PYTHON_VERSION=3.6
export HOROVOD_NCCL_HOME="/usr/local/cuda-9.0"
export HOROVOD_GPU_ALLREDUCE="NCCL"
export KERAS_BACKEND='tensorflow'
cp ~/.keras/keras_tensorflow.json ~/.keras/keras.json
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64:/usr/local/cuda-9.0/extras/CUPTI/lib64:/usr/local/cuda-9.0/lib:$LD_LIBRARY_PATH_WITHOUT_CUDA
export CUDA_PATH=/usr/local/cuda-9.0
```

```
$ cat /home/ubuntu/anaconda3/envs/pytorch_p36/etc/conda/activate.d/00_activate.sh
#!/bin/sh
export ENV_NAME=pytorch_p36
export PYTHON_VERSION=3.6
export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64:/usr/local/cuda-10.0/extras/CUPTI/lib64:/usr/local/cuda-10.0/lib:$LD_LIBRARY_PATH_WITHOUT_CUDA
export CUDA_PATH=/usr/local/cuda-10.0
export LD_LIBRARY_PATH=$HOME/anaconda3/envs/pytorch_p36/lib/python3.6/site-packages/torch/lib/:$LD_LIBRARY_PATH
```

## [NVIDIA Deep Learning AMI v17.10.0](https://aws.amazon.com/marketplace/pp/B076K31M1S)

- supports p3 only
- for running the deep learning frameworks available from the NVIDIA GPU Cloud (NGC) container registry (requires free signup)
- no CUDA, python, or tensorflow out of the box - everything is installed via docker
- tensorflow run from docker, eg: `nvidia-docker run -it --rm -v /home/ubuntu:/home/ubuntu nvcr.io/nvidia/tensorflow:17.12`
- the tensorflow:17.12 docker image contains cuDNN 7.0.5, python 2.7, tensorflow 1.4.0
- NVIDIA Driver 384.81
- Docker-ce : 17.09.0-ce, Docker Engine Utility for NVIDIA GPUs : 1.0.1
