# Tensorflow

## CUDA

Tensorflow has been built and tested with the specific CUDA versions [documented here](https://www.tensorflow.org/install/source#gpu).

It may work with other versions, eg: tensorflow 2.15 works with CUDA 12.1 - 12.4.

To show the CUDA build versions

```python
import tensorflow as tf

# Show CUDA version
print("CUDA version:", tf.sysconfig.get_build_info()['cuda_version'])

# Show cuDNN version
print("cuDNN version:", tf.sysconfig.get_build_info()['cudnn_version'])
```

## Hello world

```python
import tensorflow as tf
hello = tf.constant('Hello, TensorFlow!')
```

As a oneliner:

```python
python3 -c "import tensorflow as tf; hello = tf.constant('hello world');"

...
2023-04-17 06:19:33.884854: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1613] Created device /job:localhost/replica:0/task:0/device:GPU:0 with 13627 MB memory:  -> device: 0, name: Tesla T4, pci bus id: 0000:00:1e.0, compute capability: 7.5
```

## Docker

Tensorflow images are based on the [nvidia/cuda](https://hub.docker.com/r/nvidia/cuda) base ubuntu images and install the CUDA libraries (ie: [libcu\*.so](https://github.com/tensorflow/tensorflow/blob/c70994edddf74bef2189325c571621c2b9de38a5/tensorflow/tools/dockerfiles/dockerfiles/gpu.Dockerfile#L47)) needed and [TensorRT](https://docs.nvidia.com/deeplearning/tensorrt/install-guide/index.html) (ie: libnvinfer).

- [tensorflow/serving](https://hub.docker.com/r/tensorflow/serving/) doesn't contain python. [source](https://github.com/tensorflow/serving/blob/master/tensorflow_serving/tools/docker/Dockerfile.gpu).
- [tensorflow/tensorflow](https://hub.docker.com/r/tensorflow/tensorflow/) contains the distro python (eg: 3.8 in ubuntu20.04). [source](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu.Dockerfile)

## CPU Optimizations

When creating a `tf.Session()` you may see warnings like:

```
I tensorflow/core/platform/cpu_feature_guard.cc:140] Your CPU supports instructions that this TensorFlow binary was not compiled to use: AVX2 AVX512F FMA
```

This occurs with the standard tensorflow binaries installed via `pip install tensorflow`.

The tensorflow libraries on the AWS Deep Learning AMIs are compiled with these extensions and won't show this warning. Plus the set the following (see /home/ubuntu/anaconda3/envs/tensorflow_p36/etc/conda/activate.d/99_install_tf.sh)

```
# Since now we know that the instance is CPU instance we first need to apply MKL tuning:
CPUS_AMOUNT=`grep -c ^processor /proc/cpuinfo`

export_during_activation "OMP_NUM_THREADS="$CPUS_AMOUNT
export_during_activation "KMP_AFFINITY=granularity=fine,compact,1,0"
export_during_activation "KMP_BLOCKTIME=1"
export_during_activation "KMP_SETTINGS=0"
```

## Troubleshooting

```
tensorflow/stream_executor/platform/default/dso_loader.cc:64] Could not load dynamic library 'libcudart.so.11.0'; dlerror: libcudart.so.11.0: cannot open shared object file: No such file or directory
```

Install CUDA and make sure the packages are linked, eg: `ln -s cuda-11.2 /usr/local/cuda`

```
module 'tensorflow' has no attribute 'data'
```

Rebuild your venv, if using uv try bumping versions down and back again.

```
E external/local_xla/xla/stream_executor/cuda/cuda_dnn.cc:9261] Unable to register cuDNN factory: Attempting to register factory for plugin cuDNN when one has already been registered
E external/local_xla/xla/stream_executor/cuda/cuda_fft.cc:607] Unable to register cuFFT factory: Attempting to register factory for plugin cuFFT when one has already been registered
E external/local_xla/xla/stream_executor/cuda/cuda_blas.cc:1515] Unable to register cuBLAS factory: Attempting to register factory for plugin cuBLAS when one has already been registered
```

Harmless, see [Move duplicate CUDA/XLA registration logs from INFO to VLOG #89808](https://github.com/tensorflow/tensorflow/pull/89808)

```
I external/local_tsl/tsl/cuda/cudart_stub.cc:31] Could not find cuda drivers on your machine, GPU will not be used.
```

CUDA drivers aren't found.

You can pip install them into your .venv via:

```bash
pip install tensorflow[and-cuda]
```

Or see [nvidia](nvidia.md). If CUDA has been installed in _/usr/local/cuda_ then ensure LD_LIBRARY_PATH is set, eg:

```
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
```

```
W tensorflow/core/common_runtime/gpu/gpu_device.cc:2256] Cannot dlopen some GPU libraries. Please make sure the missing libraries mentioned above are installed properly if you would like to use GPU.
```

cudnn not found.
