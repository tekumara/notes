# CUDA

The [CUDA toolkit](https://developer.nvidia.com/cuda-toolkit) (aka CUDA) provides GPU-accelerated libraries, debugging and optimization tools, a C/C++ compiler, and a runtime library.

[NCCL](https://developer.nvidia.com/nccl) - NVIDIA Collective Communications Library (NCCL) implements multi-GPU and multi-node collective communication primitives

[cuDNN](https://developer.nvidia.com/cudnn) - a GPU-accelerated library of primitives for deep neural networks.

The [NVIDIA Container Toolkit](cuda-docker.md#nvidia-container-toolkit) allows docker containers to use GPUs.

## Install Drivers (Ubuntu)

1. Add the nvidia repo - see [nvidia-repo.sh](https://github.com/tekumara/setup-nvidia/blob/main/install/nvidia-repo.sh)
1. Install the nvidia kernel drivers - see [nvidia-drivers.sh](https://github.com/tekumara/setup-nvidia/blob/main/install/nvidia-drivers.sh)

## Install CUDA (apt)

Then install CUDA via an apt meta-package, eg: `sudo apt-get install cuda-runtime-11-2` see [NVIDIA CUDA Installation Guide for Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#package-manager-metas).

## Install CUDA (run)

eg: CUDA 12.2.2

```
# 4.1Gb
# NB: check the driver version in the URL, eg: 535.104.05 and ensure you don't have an earlier version installed
wget https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda_12.2.2_535.104.05_linux.run
chmod a+x cuda*.run

# --silent don't show the menu, auto accepts EULA
# --toolkit installs only the toolkit - not drivers, demo suite or docs
# By default, it will install into the dir /usr/local/cuda-xx.x and create the
# symlink /usr/local/cuda pointing to cuda-xx.x
# use --help for options
# takes 2:30 mins
sudo ./cuda_12.2.2_535.104.05_linux.run --silent --toolkit

# test
/usr/local/cuda/bin/nvcc --version
```

The installer creates a symlink _/usr/local/cuda_ that points to _/usr/local/cuda-xx.x_

## Test

Test:

```
nvidia-smi
```

NB: The CUDA version in the upper-right is the highest version of CUDA that is supported by the currently-installed GPU driver, and can refer to a version that isn't yet installed.

```
nvcc --version
```

```
python3 -c "import tensorflow as tf; hello = tf.constant('hello world');"
```

## Switch CUDA versions on Deep Learning Base AMI

```
cuda_ver=12.4
export LD_LIBRARY_PATH=$(echo $LD_LIBRARY_PATH | sed -E "s/cuda-12../cuda-${cuda_ver}/g")
export PATH=$(echo $PATH | sed "s/cuda-12../cuda-${cuda_ver}/g")
sudo ln -sfn "cuda-${cuda_ver}" /usr/local/cuda
```

## Troubleshooting

> Could not load dynamic library 'libcudnn.so.8'

Often stored in _/usr/local/cuda/lib/libcudnn.so.8_

If the file exists make sure its directory is on `LD_LIBRARY_PATH`.

## Redist

```
wget https://raw.githubusercontent.com/NVIDIA/build-system-archive-import-examples/refs/heads/main/parse_redist.py

# output URLs
python3 parse_redist.py -p cuda --os linux --arch x86_64 -W -l 12.2.2
python3 parse_redist.py -p cudnn --os linux --arch x86_64 -W -l 8.9.6.50

```

## Packages

```
$ apt-get install -y cuda-runtime-12-9
Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  cuda-cudart-12-9 cuda-libraries-12-9 cuda-nvrtc-12-9 cuda-opencl-12-9
  cuda-toolkit-12-9-config-common cuda-toolkit-12-config-common
  cuda-toolkit-config-common libcublas-12-9 libcufft-12-9 libcufile-12-9
  libcurand-12-9 libcusolver-12-9 libcusparse-12-9 libnpp-12-9
  libnvfatbin-12-9 libnvidia-compute-575 libnvidia-decode-575
  libnvidia-gpucomp-575 libnvjitlink-12-9 libnvjpeg-12-9
The following packages will be REMOVED:
  libnvidia-common-570 libnvidia-compute-570 libnvidia-decode-570
  libnvidia-encode-570 libnvidia-gl-570 nvidia-compute-utils-570
  nvidia-dkms-570-open nvidia-driver-570-open nvidia-firmware-570-570.133.20
  nvidia-kernel-common-570 nvidia-kernel-source-570-open nvidia-open-570
  nvidia-utils-570
The following NEW packages will be installed:
  cuda-cudart-12-9 cuda-libraries-12-9 cuda-nvrtc-12-9 cuda-opencl-12-9
  cuda-runtime-12-9 cuda-toolkit-12-9-config-common
  cuda-toolkit-12-config-common cuda-toolkit-config-common libcublas-12-9
  libcufft-12-9 libcufile-12-9 libcurand-12-9 libcusolver-12-9
  libcusparse-12-9 libnpp-12-9 libnvfatbin-12-9 libnvidia-compute-575
  libnvidia-decode-575 libnvidia-gpucomp-575 libnvjitlink-12-9 libnvjpeg-12-9
0 upgraded, 21 newly installed, 13 to remove and 37 not upgraded.
Need to get 1411 MB of archives.
After this operation, 2543 MB of additional disk space will be used.
```

## Runfile install


```
$ du -ksh /usr/local/cuda-12.2
6.7G    /usr/local/cuda-12.2
```

## References

- [NVIDIA Driver Documentation (Data Center)](https://docs.nvidia.com/datacenter/tesla/index.html)
- [NVIDIA Linux open GPU kernel module releases](https://github.com/NVIDIA/open-gpu-kernel-modules/releases)
- [NVIDIA Driver + CUDA Compatibility](https://docs.nvidia.com/deploy/cuda-compatibility/index.html)
- [CUDA Toolkit 12.9 Downloads](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_local)
- [CUDA Toolkit Archive](https://developer.nvidia.com/cuda-toolkit-archive)
- [cuDNN archive](https://developer.nvidia.com/rdp/cudnn-archive)
- [Meta Packages](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/#meta-packages) - toolkit vs runtime etc.
- [Managing Multiple CUDA + cuDNN Installations](https://medium.com/@yushantripleseven/managing-multiple-cuda-cudnn-installations-ba9cdc5e2654)
- [Step-by-Step Guide to Installing CUDA and cuDNN for GPU Acceleration](https://www.digitalocean.com/community/tutorials/install-cuda-cudnn-for-gpu#installing-cuda-on-ubuntu)
