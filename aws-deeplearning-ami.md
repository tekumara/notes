# AMIs

## [Deep Learning Base AMI (Ubuntu) v5](https://aws.amazon.com/marketplace/pp/B077GCZ4GR)
* us-east-1 ami-7cf14703 
* supports c, m, p2 & p3
* CUDA 9.0 and cuDNN 7.0.5, and NVidia Driver 384.111.
* Python 3.5.2 

## [Deep Learning AMI (Ubuntu) v12.0](https://aws.amazon.com/marketplace/pp/B077GCH38C)
* us-east-1 ami-d1c9cdae
* supports c, m, p2 & p3
* CUDA 8.0, 9.0, 9.1, 9.2 and cuDNN 7.1.4, and NVidia Driver 396.37. 
* Python 3.6.4 :: Anaconda Inc (/home/ubuntu/anaconda3/bin/python3)
* Ubuntu 16.04.4 LTS (GNU/Linux 4.4.0-1060-aws x86_64v)
* 60g disk in use
* Conda environment with Tensorflow 1.9.0 + (+Intel MKL-DNN) + Horovod. 
* On conda activatation, will install an optimised tensorflow CPU (ie: that uses AVX2 AVX512F FMA instructions) or GPU version based on the instance type - see `/home/ubuntu/anaconda3/envs/tensorflow_p36/etc/conda/activate.d/99_install_tf.sh`.

## [Deep Learning AMI (Ubuntu) v10.0](https://aws.amazon.com/marketplace/pp/B077GCH38C)
* us-east-1 ami-6d720012
* supports c, m, p2 & p3
* CUDA 9.0 and cuDNN 7.0.5, and NVidia Driver 384.111. 
* Python 3.6.4
* Ubuntu 16.04.4 LTS (GNU/Linux 4.4.0-1060-aws x86_64v)
* Conda environment with Tensorflow 1.8 + (+Intel MKL-DNN) + Horovod. 
* On conda activatation, will install an optimised tensorflow CPU (ie: that uses AVX2 AVX512F FMA instructions) or GPU version based on the instance type - see `/home/ubuntu/anaconda3/envs/tensorflow_p36/etc/conda/activate.d/99_install_tf.sh`.


## [NVIDIA Volta Deep Learning AMI v17.10.0](https://aws.amazon.com/marketplace/pp/B076K31M1S)
* supports p3 only
* for running the deep learning frameworks available from the NVIDIA GPU Cloud (NGC) container registry (requires free signup)
* no CUDA, python, or tensorflow out of the box - everything is installed via docker
* tensorflow run from docker, eg: `nvidia-docker run -it --rm -v /home/ubuntu:/home/ubuntu nvcr.io/nvidia/tensorflow:17.12`
* the tensorflow:17.12 docker image contains cuDNN 7.0.5, python 2.7, tensorflow 1.4.0
* NVIDIA Driver 384.81
* Docker-ce :   17.09.0-ce, Docker Engine Utility for NVIDIA GPUs : 1.0.1



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