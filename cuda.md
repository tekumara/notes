# CUDA

The [CUDA toolkit](https://developer.nvidia.com/cuda-toolkit) provides GPU-accelerated libraries, debugging and optimization tools, a C/C++ compiler, and a runtime library.

[NCCL](https://developer.nvidia.com/nccl) - NVIDIA Collective Communications Library (NCCL) implements multi-GPU and multi-node collective communication primitives

[cuDNN](https://developer.nvidia.com/cudnn) - a GPU-accelerated library of primitives for deep neural networks.

## Install CUDA on Ubuntu

First install the nvidia kernel drivers.

Then install CUDA, either

1. directly, eg: the [AWS Deep Learning AMI](https://aws.amazon.com/marketplace/pp/B07Y3VDBNS))
2. via apt, eg: [nvidia/container-images/cuda](https://gitlab.com/nvidia/container-images/cuda/-/tree/master/dist/10.1/ubuntu18.04-x86_64)).

Test

```
python -c "import tensorflow as tf; hello = tf.constant('hello world');"
```

See:

- [CUDA Toolkit Archive](https://developer.nvidia.com/cuda-toolkit-archive)
- [cuDNN archive](https://developer.nvidia.com/rdp/cudnn-archive)

## Container images

[nvidia/container-images/cuda](https://gitlab.com/nvidia/container-images/cuda) contains [Dockerfiles](https://gitlab.com/nvidia/container-images/cuda/-/tree/master/dist) for many distros and versions, eg: [nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/10.1/ubuntu18.04-x86_64/runtime/cudnn7/Dockerfile)

To test (requires the Nvidia Container Toolkit to be installed):

```
docker run --gpus all --rm nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04 nvidia-smi
```

To diagnose:

```
nvidia-container-cli -k -d /dev/tty info
```

See also:

- [NGC container catalog](https://ngc.nvidia.com/catalog/containers)
