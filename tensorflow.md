# Tensorflow

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

Tensorflow images are based on the [nvidia/cuda](https://hub.docker.com/r/nvidia/cuda) base ubuntu images and install the CUDA libraries (ie: [libcu*.so](https://github.com/tensorflow/tensorflow/blob/c70994edddf74bef2189325c571621c2b9de38a5/tensorflow/tools/dockerfiles/dockerfiles/gpu.Dockerfile#L47)) needed and [TensorRT](https://docs.nvidia.com/deeplearning/tensorrt/install-guide/index.html) (ie: libnvinfer).

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
