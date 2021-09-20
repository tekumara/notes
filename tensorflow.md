# Tensorflow

## Hello world

```
import tensorflow as tf
hello = tf.constant('Hello, TensorFlow!')
```

As a oneliner:

```
python3 -c "import tensorflow as tf; hello = tf.constant('hello world');"
```

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
W tensorflow/stream_executor/platform/default/dso_loader.cc:59] Could not load dynamic library 'libcudart.so.10.1'; dlerror: libcudart.so.10.1: cannot open shared object file: No such file or directory
```

Install CUDA.
