# zerofs

start:

```
SLATEDB_CACHE_DIR=/tmp SLATEDB_CACHE_SIZE_GB=4 ZEROFS_ENCRYPTION_PASSWORD=testing zerofs myprefix s3://mybucket
```

with nbd

```
SLATEDB_CACHE_DIR=/tmp SLATEDB_CACHE_SIZE_GB=4 ZEROFS_ENCRYPTION_PASSWORD=testing ZEROFS_NBD_PORTS=10809 ZEROFS_NBD_DEVICE_SIZES_GB=4 zerofs myprefix s3://mybucket
```

mount nfs

```
sudo mkdir -p /mnt/zerofs
sudo mount -t nfs -o vers=3,async,nolock,tcp,port=2049,mountport=2049,hard 127.0.0.1:/ /mnt/zerofs
```

mount nbd

```
sudo apt-get install nbd-client -y
sudo nbd-client 127.0.0.1 10809 /dev/nbd0 -N device_10809
mkfs.ext4 /dev/nbd0
mount /dev/nbd0 /mnt/nbd
```
