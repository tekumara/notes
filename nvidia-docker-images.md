# Nvidia docker images

[nvidia/cuda](https://hub.docker.com/r/nvidia/cuda) docker images are built for ubuntu but not debian. They do not contain python.

- [Docs](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda)
- [Source repo](https://gitlab.com/nvidia/container-images/cuda).

## Flavours

- `base`: Includes the CUDA runtime (cudart)
- `runtime`: Builds on the base and includes the CUDA math libraries, and NCCL. A runtime image that also includes cuDNN is available.
- `devel`: Builds on the runtime and includes headers, development tools for building CUDA images. These images are particularly useful for multi-stage builds.

eg: CUDA 11.2.1 ubuntu 20.04

| image                                                                                                                                                           | size     | additional contents                                                                                       |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | --------------------------------------------------------------------------------------------------------- |
| [nvidia/cuda:11.2.1-base-ubuntu20.04](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.1/ubuntu2004/base/Dockerfile)                     | 45 MiB   | libcudart.so.11.0, libcuda.so.1                                                                           |
| [nvidia/cuda:11.2.1-runtime-ubuntu20.04](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.1/ubuntu2004/runtime/Dockerfile)               | 1085 MiB | libcublas.so.11, libcublasLt.so.11, libcufft.so.10, libcurand.so.10, libcusolver.so.11, libcusparse.so.11 |
| [nvidia/cuda:11.2.1-cudnn8-runtime-ubuntu20.04](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.1/ubuntu2004/runtime/cudnn8/Dockerfile) | 1770 MiB | libcudnn.so.8                                                                                             |
| [nvidia/cuda:11.2.1-cudnn8-devel-ubuntu20.04](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.1/ubuntu2004/devel/cudnn8/Dockerfile)     | 3474 MiB | development tools                                                                                         |

- [nvidia/cuda:11.2.1-base-ubuntu20.04](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.1/ubuntu2004/base/Dockerfile) (45 MiB)
  - includes libcudart.so.11.0, libcuda.so.1
- [nvidia/cuda:11.2.1-runtime-ubuntu20.04](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.1/ubuntu2004/runtime/Dockerfile) (1085 MiB)
  - includes libcublas.so.11, libcublasLt.so.11, libcufft.so.10, libcurand.so.10, libcusolver.so.11, libcusparse.so.11
- [nvidia/cuda:11.2.1-cudnn8-runtime-ubuntu20.04](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.1/ubuntu2004/runtime/cudnn8/Dockerfile) (1770 MiB)
  - includes libcudnn.so.8
- [nvidia/cuda:11.2.1-cudnn8-devel-ubuntu20.04](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.1/ubuntu2004/devel/cudnn8/Dockerfile) (3474 MiB)
  - includes development tools
