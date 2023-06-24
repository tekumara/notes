# CUDA

The [CUDA toolkit](https://developer.nvidia.com/cuda-toolkit) provides GPU-accelerated libraries, debugging and optimization tools, a C/C++ compiler, and a runtime library.

[NCCL](https://developer.nvidia.com/nccl) - NVIDIA Collective Communications Library (NCCL) implements multi-GPU and multi-node collective communication primitives

[cuDNN](https://developer.nvidia.com/cudnn) - a GPU-accelerated library of primitives for deep neural networks.

The [NVIDIA Container Toolkit](cuda-docker.md#nvidia-container-toolkit) allows docker containers to use GPUs.

## Install CUDA on Ubuntu

First install the nvidia kernel drivers.

Then install CUDA, either

1. Indirectly by using the [AWS Deep Learning AMI](https://aws.amazon.com/marketplace/pp/B07Y3VDBNS))
2. On Ubuntu via an apt meta-package, eg: `sudo apt-get install cuda-runtime-11-2` see [NVIDIA CUDA Installation Guide for Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#package-manager-metas).

Test

```
nvidia-smi
```

```
nvcc --version
```

```
python3 -c "import tensorflow as tf; hello = tf.constant('hello world');"
```

## Troubleshooting

> Could not load dynamic library 'libcudnn.so.8'

Often stored in _/usr/local/cuda/lib/libcudnn.so.8_

If the file exists make sure its directory is on `LD_LIBRARY_PATH`.

## References

- [CUDA Toolkit Archive](https://developer.nvidia.com/cuda-toolkit-archive)
- [cuDNN archive](https://developer.nvidia.com/rdp/cudnn-archive)
