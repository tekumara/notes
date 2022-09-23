# CUDA in docker

## Images

[nvidia/cuda](https://hub.docker.com/r/nvidia/cuda) docker images are built for ubuntu but not debian. They do not contain python.

- [Docs](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda)
- [Source repo](https://gitlab.com/nvidia/container-images/cuda)

### Flavours

- `base`: Includes the CUDA runtime (cudart)
- `runtime`: Builds on the base and includes the CUDA math libraries, and NCCL. A runtime image that also includes cuDNN is available.
- `devel`: Builds on the runtime and includes headers, development tools for building CUDA images. These images are particularly useful for multi-stage builds.
- `cudnn8`: Build on either the devel or runtime images and includes [cuDNN](https://developer.nvidia.com
  eg: CUDA 11.2.2 ubuntu 20.04

| image                                                                                                                                                           | compressed size | additional contents                                                                                       |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- | --------------------------------------------------------------------------------------------------------- |
| [nvidia/cuda:11.2.2-base-ubuntu20.04](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.2/ubuntu2004/base/Dockerfile)                     | 45 MiB          | libcudart.so.11.0, libcuda.so.1                                                                           |
| [nvidia/cuda:11.2.2-runtime-ubuntu20.04](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.2/ubuntu2004/runtime/Dockerfile)               | 1085 MiB        | libcublas.so.11, libcublasLt.so.11, libcufft.so.10, libcurand.so.10, libcusolver.so.11, libcusparse.so.11 |
| [nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.2/ubuntu2004/runtime/cudnn8/Dockerfile) | 1770 MiB        | libcudnn.so.8                                                                                             |
| [nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.2/ubuntu2004/devel/cudnn8/Dockerfile)     | 3474 MiB        | development tools                                                                                         |

Tensorflow requires at least a cuda:11.2.2-cudnn8-runtime image.

## Nvidia container toolkit

The [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/overview.html) uses a pre-start hook triggered by the presence of [nvidia-container-runtime environment variables](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/user-guide.html#environment-variables-oci-spec). The hook makes `nvidia-smi`, the nvidia drivers, and `/proc/driver/nvidia` and `/dev/nvidia*` available within the container.

For CUDA applications, the container image must also have CUDA installed.

See also

- [nvidia-docker2 > nvidia-container-runtime > nvidia-container-toolkit > libnvidia-container](https://github.com/NVIDIA/nvidia-docker/issues/1268#issuecomment-632692949)
- [NVIDIA/nvidia-docker repo](https://github.com/NVIDIA/nvidia-docker)
- [nvidia-container-runtime](https://github.com/NVIDIA/nvidia-container-runtime)

## Testing

To test (requires the Nvidia Container Toolkit to be installed):

```
docker run --gpus all --rm nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04 nvidia-smi
```

To diagnose:

```
nvidia-container-cli -k -d /dev/tty info
```

Tensorflow:

```
python -c "import tensorflow as tf; hello = tf.constant('hello world');"
```

## Troubleshooting

> CUDA Version: N/A

or

> Could not load dynamic library 'libcuda.so.1'

If `nvida-smi` shows `CUDA Version: N/A` or an application cannot load `libcuda.so.1` make sure:

- the host has the Nvidia container toolkit installed
- the docker image contains CUDA
- if run via docker, the container has been started with `docker run --gpus all`. This sets the `NVIDIA_VISIBLE_DEVICES=all` env var inside the container, which triggers the pre-start hook.  
- if run via kubernetes, the docker image or pod spec must have the following [nvidia-container-runtime environment variables](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/user-guide.html#environment-variables-oci-spec) set to trigger the pre-start hook:

  ```
  # nvidia-container-runtime
  ENV NVIDIA_VISIBLE_DEVICES all
  ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
  ```
