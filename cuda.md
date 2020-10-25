# CUDA

The [CUDA toolkit](https://developer.nvidia.com/cuda-toolkit) provides GPU-accelerated libraries, debugging and optimization tools, a C/C++ compiler, and a runtime library.

[NCCL](https://developer.nvidia.com/nccl) - NVIDIA Collective Communications Library (NCCL) implements multi-GPU and multi-node collective communication primitives

[cuDNN](https://developer.nvidia.com/cudnn) - a GPU-accelerated library of primitives for deep neural networks.

## Install CUDA

TensorFlow provides these [instructions for installing CUDA 10.1, cuDNN 7 on Ubunutu 18.04](https://www.tensorflow.org/install/gpu#ubuntu_1804_cuda_101) which download ~2.5GB:

```
# Add NVIDIA package repositories
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.1.243-1_amd64.deb
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo dpkg -i cuda-repo-ubuntu1804_10.1.243-1_amd64.deb
sudo apt-get update
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt install ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt-get update

# Install NVIDIA driver kernel module (~150MB)
sudo apt-get install --no-install-recommends nvidia-driver-450


# Install development and runtime libraries (~4GB)
sudo apt-get install --no-install-recommends \
    cuda-10-1 \
    libcudnn7=7.6.5.32-1+cuda10.1  \
    libcudnn7-dev=7.6.5.32-1+cuda10.1

# Reboot. Check that GPUs are visible using the command: nvidia-smi
```

Make sure you reboot at the end, because the final cuda package install updates the nvidia driver.

Check the [tensorflow repo issues](https://github.com/tensorflow/tensorflow/issues) for troubleshooting.

For other combinations see:

- [CUDA Toolkit Archive](https://developer.nvidia.com/cuda-toolkit-archive)
- [cuDNN archive](https://developer.nvidia.com/rdp/cudnn-archive)

## Container images

[nvidia/container-images/cuda](https://gitlab.com/nvidia/container-images/cuda) contains [Dockerfiles](https://gitlab.com/nvidia/container-images/cuda/-/tree/master/dist) for many distros and versions, eg: [nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/10.1/ubuntu18.04-x86_64/runtime/cudnn7/Dockerfile)

See

- [NGC container catalog](https://ngc.nvidia.com/catalog/containers)
