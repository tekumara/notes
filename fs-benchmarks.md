# filesystem benchmarks

t3.xlarge

zerofs nfs Disk: 4.00GB (all to SlateDB), Memory: SlateDB block cache: 0.06GB, ZeroFS cache: 0.25GB

fsx openzfs SSD 128 MB/s Provisioned IOPS 6000: mount -t nfs -o nfsvers=4.1 "$fsx_hostname":/fsx/ /mnt/fsx

fsx lustre 1.2 TiB 125 MB/s/TiB SSD 1500 Metadata 1500 IOPS: mount -t lustre -o relatime,flock "$fsx_hostname@tcp:/$mount_name" /mnt/lustre

mount -t nfs -o nfsvers=4.1,nconnect=16 "$fsx_hostname":/fsx/ /mnt/fsx

## benchmarks

### real world

## Real World Benchmark Summary

| Storage System                | uv sync | rm -rf .venv | Performance Notes           |
| ----------------------------- | ------- | ------------ | --------------------------- |
| **EBS GP3**                   | 24.664s | 1.208s       | ⭐ Best overall - local SSD |
| **FSx OpenZFS**               | 1:18.94 | 33.622s      | Good network storage        |
| **FSx OpenZFS (nconnect=16)** | 1:20.58 | 43.139s      | Parallel connections        |
| **FSx OpenZFS (optimized)**   | 1:11.97 | 33.894s      | NFSv4.2 + tuning            |
| **FSx Lustre**                | 1:53.82 | 1:02.60      | High-performance parallel   |
| **ZeroFS NFS**                | 2:56.48 | 51.176s      | Slowest option              |

zerofs nfs:

```
❯ uv sync --all-extras --all-packages --group lint --group docs --no-cache  15.49s user 23.59s system 22% cpu 2:56.48 total

❯ time rm -rf .venv
rm -rf .venv  0.37s user 5.17s system 10% cpu 51.176 total
```

fsx openzfs

```
❯ uv sync --all-extras --all-packages --group lint --group docs --no-cache  15.49s user 19.48s system 44% cpu 1:18.94 total

❯ time rm -rf .venv
rm -rf .venv  0.17s user 3.47s system 10% cpu 33.622 total
```

fsx openzfs -o nconnect=16

```
❯ uv sync --all-extras --all-packages --group lint --group docs --no-cache 13.91s user 18.99s system 40% cpu 1:20.58 total

❯ time rm -rf .venv
rm -rf .venv 0.18s user 4.01s system 9% cpu 43.139 total
```

fsx openzfs -o nfsvers=3,nconnect=16,hard,async,fsc,noatime,nodiratime,relatime

```
❯ time rm -rf .venv
rm -rf .venv  0.20s user 4.18s system 10% cpu 42.088 total
```

fsx openzfs -t nfs4 -o vers=4.2,async,noatime,nodiratime,rsize=524288,wsize=524288,actimeo=120,hard,intr

```
uv sync --all-extras --all-packages --group lint --group docs --no-cache  13.73s user 17.72s system 43% cpu 1:11.97 total

❯ time rm -rf .venv
rm -rf .venv  0.19s user 3.26s system 10% cpu 33.894 total
```

fsx lustre

```
❯ uv sync --all-extras --all-packages --group lint --group docs --no-cache 15.38s user 40.34s system 48% cpu 1:53.82 total

❯ time rm -rf .venv
rm -rf .venv 0.22s user 9.70s system 15% cpu 1:02.60 total
```

ebs gp3:

```
❯ uv sync --all-extras --all-packages --group lint --group docs --no-cache 13.64s user 11.06s system 100% cpu 24.664 total

❯ time rm -rf .venv
rm -rf .venv 0.05s user 1.15s system 99% cpu 1.208 total
```

### fio

| Storage System          | Total IOPS | Read BW    | Write BW   | Test Duration | CPU Usage | Performance Ranking |
| ----------------------- | ---------- | ---------- | ---------- | ------------- | --------- | ------------------- |
| Tank/Test (NVMe)        | 63.3k      | 124 MiB/s  | 124 MiB/s  | 4.1 sec       | 94.7% sys | 1st - Excellent     |
| openzfs                 | 14.3k      | 27.9 MiB/s | 27.8 MiB/s | 9.0 sec       | 12.4% sys | 2nd - Good          |
| Lustre                  | 6.0k       | 11.8 MiB/s | 11.7 MiB/s | 21 sec        | 13.7% sys | 3rd - Fair          |
| EBS                     | 3.1k       | 6.0 MiB/s  | 6.0 MiB/s  | 42 sec        | 2.7% sys  | 4th - Moderate      |
| ZeroFS NBD (10GB cache) | 3.0k       | 6.0 MiB/s  | 5.9 MiB/s  | 43 sec        | 2.8% sys  | 5th - Moderate      |
| ZeroFS NBD              | 1.4k       | 2.8 MiB/s  | 2.8 MiB/s  | 90 sec        | 6.8% sys  | 5th - Fair          |
| ZeroFS 1M rsize/wsize   | 1.3k       | 2.5 MiB/s  | 2.5 MiB/s  | 101 sec       | 2.3% sys  | 6th - Fair          |
| ZeroFS large cache      | 0.9k       | 1.8 MiB/s  | 1.8 MiB/s  | 142 sec       | 1.8% sys  | 7th - Poor          |
| ZeroFS small cache      | 0.4k       | 0.9 MiB/s  | 0.9 MiB/s  | 289 sec       | 0.9% sys  | 8th - Poor          |

fsx (openzfs):

```
❯ fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --bs=4k --iodepth=64 --readwrite=randrw --rwmixread=50 --size=500MB --filename=/mnt/fsx/delme
test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.28
Starting 1 process
test: Laying out IO file (1 file / 500MiB)
Jobs: 1 (f=1): [m(1)][100.0%][r=33.7MiB/s,w=33.4MiB/s][r=8620,w=8553 IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=12248: Sat Jul 19 10:55:57 2025
read: IOPS=7145, BW=27.9MiB/s (29.3MB/s)(251MiB/8979msec)
bw ( KiB/s): min=25688, max=35208, per=98.51%, avg=28158.59, stdev=2487.12, samples=17
iops : min= 6422, max= 8802, avg=7039.65, stdev=621.78, samples=17
write: IOPS=7109, BW=27.8MiB/s (29.1MB/s)(249MiB/8979msec); 0 zone resets
bw ( KiB/s): min=25032, max=36352, per=98.73%, avg=28078.59, stdev=2698.83, samples=17
iops : min= 6258, max= 9088, avg=7019.65, stdev=674.71, samples=17
cpu : usr=4.30%, sys=12.36%, ctx=46923, majf=0, minf=6
IO depths : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
issued rwts: total=64163,63837,0,0 short=0,0,0,0 dropped=0,0,0,0
latency : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
READ: bw=27.9MiB/s (29.3MB/s), 27.9MiB/s-27.9MiB/s (29.3MB/s-29.3MB/s), io=251MiB (263MB), run=8979-8979msec
WRITE: bw=27.8MiB/s (29.1MB/s), 27.8MiB/s-27.8MiB/s (29.1MB/s-29.1MB/s), io=249MiB (261MB), run=8979-8979msec
```

zerofs small cache Disk: 4.00GB (all to SlateDB), Memory: SlateDB block cache: 0.06GB, ZeroFS cache: 0.25GB

```
❯ fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --bs=4k --iodepth=64 --readwrite=randrw --rwmixread=50 --size=500MB --filename=/mnt/zerofs/delme
test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.28
Starting 1 process
test: Laying out IO file (1 file / 500MiB)
Jobs: 1 (f=1): [m(1)][99.7%][r=1096KiB/s,w=932KiB/s][r=274,w=233 IOPS][eta 00m:01s]
test: (groupid=0, jobs=1): err= 0: pid=12285: Sat Jul 19 11:01:02 2025
read: IOPS=221, BW=887KiB/s (908kB/s)(251MiB/289423msec)
bw ( KiB/s): min= 24, max= 2448, per=99.80%, avg=885.75, stdev=574.71, samples=578
iops : min= 6, max= 612, avg=221.43, stdev=143.68, samples=578
write: IOPS=220, BW=882KiB/s (903kB/s)(249MiB/289423msec); 0 zone resets
bw ( KiB/s): min= 24, max= 2296, per=99.86%, avg=881.42, stdev=565.57, samples=578
iops : min= 6, max= 574, avg=220.34, stdev=141.40, samples=578
cpu : usr=0.37%, sys=0.90%, ctx=125664, majf=0, minf=6
IO depths : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
issued rwts: total=64163,63837,0,0 short=0,0,0,0 dropped=0,0,0,0
latency : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
READ: bw=887KiB/s (908kB/s), 887KiB/s-887KiB/s (908kB/s-908kB/s), io=251MiB (263MB), run=289423-289423msec
WRITE: bw=882KiB/s (903kB/s), 882KiB/s-882KiB/s (903kB/s-903kB/s), io=249MiB (261MB), run=289423-289423msec
```

zerofs large cache Disk: 4.00GB (all to SlateDB), Memory: SlateDB block cache: 0.50GB, ZeroFS cache: 2.00GB

```
❯ fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --bs=4k --iodepth=64 --readwrite=randrw --rwmixread=50 --size=500MB --filename=/mnt/zerofs/delme
test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.28
Starting 1 process
Jobs: 1 (f=1): [m(1)][100.0%][r=1973KiB/s,w=1841KiB/s][r=493,w=460 IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=35452: Sun Jul 20 12:17:55 2025
  read: IOPS=450, BW=1801KiB/s (1845kB/s)(251MiB/142469msec)
   bw (  KiB/s): min=    8, max= 3536, per=100.00%, avg=1816.16, stdev=919.85, samples=282
   iops        : min=    2, max=  884, avg=454.02, stdev=229.96, samples=282
  write: IOPS=448, BW=1792KiB/s (1835kB/s)(249MiB/142469msec); 0 zone resets
   bw (  KiB/s): min=   16, max= 3528, per=100.00%, avg=1800.85, stdev=908.91, samples=283
   iops        : min=    4, max=  882, avg=450.19, stdev=227.23, samples=283
  cpu          : usr=0.71%, sys=1.78%, ctx=124300, majf=0, minf=7
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=64163,63837,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=1801KiB/s (1845kB/s), 1801KiB/s-1801KiB/s (1845kB/s-1845kB/s), io=251MiB (263MB), run=142469-142469msec
  WRITE: bw=1792KiB/s (1835kB/s), 1792KiB/s-1792KiB/s (1835kB/s-1835kB/s), io=249MiB (261MB), run=142469-142469msec
```

zerofs 1M rsize/wsize Disk: 4.00GB (all to SlateDB), Memory: SlateDB block cache: 0.50GB, ZeroFS cache: 2.00GB + nfs rsize=1048576,wsize=1048576

```
❯ fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --bs=4k --iodepth=64 --readwrite=randrw --rwmixread=50 --size=500MB --filename=/mnt/zerofs/delme
test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.28
Starting 1 process
Jobs: 1 (f=1): [m(1)][100.0%][r=2706KiB/s,w=2774KiB/s][r=676,w=693 IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=36140: Sun Jul 20 12:25:58 2025
  read: IOPS=638, BW=2553KiB/s (2614kB/s)(251MiB/100540msec)
   bw (  KiB/s): min=  590, max= 3848, per=99.97%, avg=2552.87, stdev=712.96, samples=200
   iops        : min=  147, max=  962, avg=638.17, stdev=178.25, samples=200
  write: IOPS=634, BW=2540KiB/s (2601kB/s)(249MiB/100540msec); 0 zone resets
   bw (  KiB/s): min=  742, max= 3768, per=100.00%, avg=2541.12, stdev=711.24, samples=200
   iops        : min=  185, max=  942, avg=635.23, stdev=177.82, samples=200
  cpu          : usr=0.92%, sys=2.29%, ctx=126797, majf=0, minf=7
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=64163,63837,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=2553KiB/s (2614kB/s), 2553KiB/s-2553KiB/s (2614kB/s-2614kB/s), io=251MiB (263MB), run=100540-100540msec
  WRITE: bw=2540KiB/s (2601kB/s), 2540KiB/s-2540KiB/s (2601kB/s-2601kB/s), io=249MiB (261MB), run=100540-100540msec
```

zerofs nbd disk: 4.00GB (all to SlateDB), Memory: SlateDB block cache: 0.50GB, ZeroFS cache: 2.00GB

```
❯ fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --bs=4k --iodepth=64 --readwrite=randrw --rwmixread=50 --size=500MB --filename=/mnt/n
bd/delme
test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.28
Starting 1 process
test: Laying out IO file (1 file / 500MiB)
Jobs: 1 (f=1): [m(1)][100.0%][r=3448KiB/s,w=3508KiB/s][r=862,w=877 IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=37082: Sun Jul 20 12:43:01 2025
  read: IOPS=716, BW=2866KiB/s (2935kB/s)(251MiB/89550msec)
   bw (  KiB/s): min=   32, max= 4792, per=100.00%, avg=3204.31, stdev=915.54, samples=159
   iops        : min=    8, max= 1198, avg=801.00, stdev=228.90, samples=159
  write: IOPS=712, BW=2851KiB/s (2920kB/s)(249MiB/89550msec); 0 zone resets
   bw (  KiB/s): min=   24, max= 4536, per=100.00%, avg=3191.47, stdev=890.33, samples=159
   iops        : min=    6, max= 1134, avg=797.76, stdev=222.60, samples=159
  cpu          : usr=1.08%, sys=6.80%, ctx=124316, majf=0, minf=7
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=64163,63837,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=2866KiB/s (2935kB/s), 2866KiB/s-2866KiB/s (2935kB/s-2935kB/s), io=251MiB (263MB), run=89550-89550msec
  WRITE: bw=2851KiB/s (2920kB/s), 2851KiB/s-2851KiB/s (2920kB/s-2920kB/s), io=249MiB (261MB), run=89550-89550msec

Disk stats (read/write):
  nbd0: ios=63969/63694, merge=0/21, ticks=2823871/2865253, in_queue=5705118, util=99.99%
```

zerofs nbd ZeroFS cache: 10GB

```
❯ fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --bs=4k --iodepth=64 --readwrite=randrw --rwmixread=50 --size=500MB --filename=/mnt/nbd/delme
test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.28
Starting 1 process
test: Laying out IO file (1 file / 500MiB)
Jobs: 1 (f=1): [m(1)][100.0%][r=6024KiB/s,w=5728KiB/s][r=1506,w=1432 IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=38814: Sun Jul 20 12:56:04 2025
  read: IOPS=1507, BW=6032KiB/s (6177kB/s)(251MiB/42550msec)
   bw (  KiB/s): min= 5560, max=17376, per=100.00%, avg=6034.68, stdev=1254.66, samples=85
   iops        : min= 1390, max= 4344, avg=1508.67, stdev=313.67, samples=85
  write: IOPS=1500, BW=6001KiB/s (6145kB/s)(249MiB/42550msec); 0 zone resets
   bw (  KiB/s): min= 5264, max=18280, per=100.00%, avg=6003.91, stdev=1360.12, samples=85
   iops        : min= 1316, max= 4570, avg=1500.98, stdev=340.03, samples=85
  cpu          : usr=1.08%, sys=2.82%, ctx=33662, majf=0, minf=7
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=64163,63837,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=6032KiB/s (6177kB/s), 6032KiB/s-6032KiB/s (6177kB/s-6177kB/s), io=251MiB (263MB), run=42550-42550msec
  WRITE: bw=6001KiB/s (6145kB/s), 6001KiB/s-6001KiB/s (6145kB/s-6145kB/s), io=249MiB (261MB), run=42550-42550msec

Disk stats (read/write):
  nvme0n1: ios=65905/64805, merge=0/7224, ticks=708094/712286, in_queue=1420381, util=94.56%
```

ebs

```
❯ fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --bs=4k --iodepth=64 --readwrite=randrw --rwmixread=50 --size=500MB --filename=$HOME/ebs
test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.28
Starting 1 process
test: Laying out IO file (1 file / 500MiB) Jobs: 1 (f=1): [m(1)][100.0%][r=6098KiB/s,w=5909KiB/s][r=1524,w=1477 IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=30725: Sat Jul 19 23:44:44 2025
read: IOPS=1539, BW=6157KiB/s (6305kB/s)(251MiB/41683msec)
bw ( KiB/s): min= 5632, max=17416, per=100.00%, avg=6160.10, stdev=1261.10, samples=83
iops : min= 1408, max= 4354, avg=1540.02, stdev=315.28, samples=83
write: IOPS=1531, BW=6126KiB/s (6273kB/s)(249MiB/41683msec); 0 zone resets
bw ( KiB/s): min= 5544, max=18304, per=100.00%, avg=6130.60, stdev=1361.51, samples=83
iops : min= 1386, max= 4576, avg=1532.65, stdev=340.38, samples=83
cpu : usr=0.99%, sys=2.66%, ctx=29675, majf=0, minf=7
IO depths : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
issued rwts: total=64163,63837,0,0 short=0,0,0,0 dropped=0,0,0,0
latency : target=0, window=0, percentile=100.00%, depth=64
Run status group 0 (all jobs):
READ: bw=6157KiB/s (6305kB/s), 6157KiB/s-6157KiB/s (6305kB/s-6305kB/s), io=251MiB (263MB), run=41683-41683msec
WRITE: bw=6126KiB/s (6273kB/s), 6126KiB/s-6126KiB/s (6273kB/s-6273kB/s), io=249MiB (261MB), run=41683-41683msec
Disk stats (read/write):
nvme0n1: ios=64082/63806, merge=0/32, ticks=707441/722946, in_queue=1430386, util=96.58%
```

lustre

```
❯ fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --bs=4k --iodepth=64 --readwrite=randrw --rwmixread=50 --size=500MB --filename=/mnt/lustre/fio
test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.28
Starting 1 process
test: Laying out IO file (1 file / 500MiB)
Jobs: 1 (f=1): [m(1)][100.0%][r=16.9MiB/s,w=16.9MiB/s][r=4337,w=4331 IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=6997: Sun Jul 20 03:31:29 2025
read: IOPS=3009, BW=11.8MiB/s (12.3MB/s)(251MiB/21317msec)
bw ( KiB/s): min= 616, max=20784, per=100.00%, avg=12126.83, stdev=5424.24, samples=41
iops : min= 154, max= 5196, avg=3031.71, stdev=1356.06, samples=41
write: IOPS=2994, BW=11.7MiB/s (12.3MB/s)(249MiB/21317msec); 0 zone resets
bw ( KiB/s): min= 616, max=20752, per=100.00%, avg=12082.15, stdev=5370.02, samples=41
iops : min= 154, max= 5188, avg=3020.54, stdev=1342.51, samples=41
cpu : usr=1.79%, sys=13.69%, ctx=25643, majf=0, minf=6
IO depths : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
issued rwts: total=64163,63837,0,0 short=0,0,0,0 dropped=0,0,0,0
latency : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
READ: bw=11.8MiB/s (12.3MB/s), 11.8MiB/s-11.8MiB/s (12.3MB/s-12.3MB/s), io=251MiB (263MB), run=21317-21317msec
WRITE: bw=11.7MiB/s (12.3MB/s), 11.7MiB/s-11.7MiB/s (12.3MB/s-12.3MB/s), io=249MiB (261MB), run=21317-21317msec
```

## mdtest

install

```
wget https://github.com/hpc/ior/releases/download/4.0.0/ior-4.0.0.tar.gz
tar -xzf ior-4.0.0.tar.gz
sudo apt install openmpi-bin openmpi-common libopenmpi-dev
cd ior
./configure
make install
```

2 tasks, 1000 files and directories created each

-d . run in current directory.
-z 3 depth 3
-b 2 branching factor 2

```
mpirun -n 2 mdtest -n 1000 -z 3 -b 2 -d .
```

ebs

```
❯ mpirun -n 2 mdtest -n 1000 -z 3 -b 2 -d $HOME

-- started at 07/20/2025 06:01:28 --

mdtest-4.0.0 was launched with 2 total task(s) on 1 node(s)
Command line used: mdtest '-n' '1000' '-z' '3' '-b' '2' '-d' '/home/compute'
WARNING: Read bytes is 0, thus, a read test will actually just open/close
Path : /home/compute
FS : 135.5 GiB Used FS: 25.4% Inodes: 17.2 Mi Used Inodes: 3.1%
WARNING: Read bytes is 0, thus, a read test will actually just open/close
Nodemap: 11
2 tasks, 1980 files/directories

SUMMARY rate: (of 1 iterations)
Operation Max Min Mean Std Dev

---

Directory creation 42309.509 42309.509 42309.509 0.000
Directory stat 748915.314 748915.314 748915.314 0.000
Directory rename 37823.868 37823.868 37823.868 0.000
Directory removal 54682.377 54682.377 54682.377 0.000
File creation 60178.708 60178.708 60178.708 0.000
File stat 476188.183 476188.183 476188.183 0.000
File read 143730.044 143730.044 143730.044 0.000
File removal 87556.372 87556.372 87556.372 0.000
Tree creation 39053.110 39053.110 39053.110 0.000
Tree removal 7940.750 7940.750 7940.750 0.000
-- finished at 07/20/2025 06:01:29 --
```

fsx openzfs

```
❯ mpirun -n 2 mdtest -n 1000 -z 3 -b 2 -d /mnt/fsx/
-- started at 07/20/2025 06:01:51 --

mdtest-4.0.0 was launched with 2 total task(s) on 1 node(s)
Command line used: mdtest '-n' '1000' '-z' '3' '-b' '2' '-d' '/mnt/fsx/'
WARNING: Read bytes is 0, thus, a read test will actually just open/close
WARNING: Read bytes is 0, thus, a read test will actually just open/close
Path : /mnt/fsx/
FS : 999.4 GiB Used FS: 83.9% Inodes: 348.6 Mi Used Inodes: 7.6%
Nodemap: 11
2 tasks, 1980 files/directories

SUMMARY rate: (of 1 iterations)
Operation Max Min Mean Std Dev

---

Directory creation 1322.498 1322.498 1322.498 0.000
Directory stat 24152.516 24152.516 24152.516 0.000
Directory rename 1108.155 1108.155 1108.155 0.000
Directory removal 1291.190 1291.190 1291.190 0.000
File creation 985.840 985.840 985.840 0.000
File stat 473230.493 473230.493 473230.493 0.000
File read 1872.404 1872.404 1872.404 0.000
File removal 1460.626 1460.626 1460.626 0.000
Tree creation 828.772 828.772 828.772 0.000
Tree removal 1101.156 1101.156 1101.156 0.000
-- finished at 07/20/2025 06:02:02 --
```

fsx lustre

```
❯ mpirun -n 2 mdtest -n 1000 -z 3 -b 2 -d /mnt/lustre/
WARNING: Read bytes is 0, thus, a read test will actually just open/close
-- started at 07/20/2025 06:02:32 --

mdtest-4.0.0 was launched with 2 total task(s) on 1 node(s)
Command line used: mdtest '-n' '1000' '-z' '3' '-b' '2' '-d' '/mnt/lustre/'
WARNING: Read bytes is 0, thus, a read test will actually just open/close
Path : /mnt/lustre/
FS : 1.1 TiB Used FS: 0.1% Inodes: 4.2 Mi Used Inodes: 0.0%
Nodemap: 11
2 tasks, 1980 files/directories

SUMMARY rate: (of 1 iterations)
Operation Max Min Mean Std Dev

---

Directory creation 2820.420 2820.420 2820.420 0.000
Directory stat 4631.339 4631.339 4631.339 0.000
Directory rename 1040.439 1040.439 1040.439 0.000
Directory removal 1729.016 1729.016 1729.016 0.000
File creation 1910.962 1910.962 1910.962 0.000
File stat 3084.406 3084.406 3084.406 0.000
File read 2533.019 2533.019 2533.019 0.000
File removal 1331.007 1331.007 1331.007 0.000
Tree creation 1644.395 1644.395 1644.395 0.000
Tree removal 2772.666 2772.666 2772.666 0.000
-- finished at 07/20/2025 06:02:41 --
```

fsx openzfs nconnect=16

```
❯ mpirun -n 2 mdtest -n 1000 -z 3 -b 2 -d /mnt/fsx/
-- started at 07/20/2025 06:20:34 --

mdtest-4.0.0 was launched with 2 total task(s) on 1 node(s)
Command line used: mdtest '-n' '1000' '-z' '3' '-b' '2' '-d' '/mnt/fsx/'
WARNING: Read bytes is 0, thus, a read test will actually just open/close
WARNING: Read bytes is 0, thus, a read test will actually just open/close
Path : /mnt/fsx/
FS : 999.4 GiB Used FS: 83.9% Inodes: 348.6 Mi Used Inodes: 7.6%
Nodemap: 11
2 tasks, 1980 files/directories

SUMMARY rate: (of 1 iterations)
Operation Max Min Mean Std Dev

---

Directory creation 1214.288 1214.288 1214.288 0.000
Directory stat 24616.211 24616.211 24616.211 0.000
Directory rename 1056.861 1056.861 1056.861 0.000
Directory removal 1259.589 1259.589 1259.589 0.000
File creation 995.437 995.437 995.437 0.000
File stat 458976.562 458976.562 458976.562 0.000
File read 2075.907 2075.907 2075.907 0.000
File removal 1534.523 1534.523 1534.523 0.000
Tree creation 776.033 776.033 776.033 0.000
Tree removal 1118.143 1118.143 1118.143 0.000
-- finished at 07/20/2025 06:20:45 --
```

fsx openzfs nfsvers=3

```
❯ mpirun -n 2 mdtest -n 1000 -z 3 -b 2 -d /mnt/fsx/
-- started at 07/20/2025 06:34:06 --

mdtest-4.0.0 was launched with 2 total task(s) on 1 node(s)
Command line used: mdtest '-n' '1000' '-z' '3' '-b' '2' '-d' '/mnt/fsx/'
WARNING: Read bytes is 0, thus, a read test will actually just open/close
WARNING: Read bytes is 0, thus, a read test will actually just open/close
Path                : /mnt/fsx/
FS                  : 999.4 GiB   Used FS: 83.9%   Inodes: 348.6 Mi   Used Inodes: 7.6%
Nodemap: 11
2 tasks, 1980 files/directories

SUMMARY rate: (of 1 iterations)
   Operation                     Max            Min           Mean        Std Dev
   ---------                     ---            ---           ----        -------
   Directory creation           1878.761       1878.761       1878.761          0.000
   Directory stat             504202.654     504202.654     504202.654          0.000
   Directory rename             1130.155       1130.155       1130.155          0.000
   Directory removal            2357.126       2357.126       2357.126          0.000
   File creation                 833.758        833.758        833.758          0.000
   File stat                  504999.813     504999.813     504999.813          0.000
   File read                    3253.193       3253.193       3253.193          0.000
   File removal                 1672.043       1672.043       1672.043          0.000
   Tree creation                 595.500        595.500        595.500          0.000
   Tree removal                 1140.438       1140.438       1140.438          0.000
-- finished at 07/20/2025 06:34:15 --
```

fsx openzfs -o vers=4.2,async,noatime,nodiratime,rsize=524288,wsize=524288,actimeo=120,hard,intr

```
❯ mpirun -n 2 mdtest -n 1000 -z 3 -b 2 -d /mnt/fsx/
WARNING: Read bytes is 0, thus, a read test will actually just open/close
-- started at 07/20/2025 07:07:31 --

mdtest-4.0.0 was launched with 2 total task(s) on 1 node(s)
Command line used: mdtest '-n' '1000' '-z' '3' '-b' '2' '-d' '/mnt/fsx/'
WARNING: Read bytes is 0, thus, a read test will actually just open/close
Path                : /mnt/fsx/
FS                  : 999.4 GiB   Used FS: 83.8%   Inodes: 349.4 Mi   Used Inodes: 7.5%
Nodemap: 11
2 tasks, 1980 files/directories

SUMMARY rate: (of 1 iterations)
   Operation                     Max            Min           Mean        Std Dev
   ---------                     ---            ---           ----        -------
   Directory creation           1219.275       1219.275       1219.275          0.000
   Directory stat              90118.845      90118.845      90118.845          0.000
   Directory rename             1169.982       1169.982       1169.982          0.000
   Directory removal            1681.702       1681.702       1681.702          0.000
   File creation                1031.369       1031.369       1031.369          0.000
   File stat                  476078.991     476078.991     476078.991          0.000
   File read                    2166.755       2166.755       2166.755          0.000
   File removal                 1606.374       1606.374       1606.374          0.000
   Tree creation                 847.505        847.505        847.505          0.000
   Tree removal                 1104.636       1104.636       1104.636          0.000
-- finished at 07/20/2025 07:07:40 --
```

zerofs nbd ZeroFS cache: 10GB

```
❯ mpirun -n 2 mdtest -n 1000 -z 3 -b 2 -d /mnt/nbd/
-- started at 07/20/2025 12:59:52 --

mdtest-4.0.0 was launched with 2 total task(s) on 1 node(s)
Command line used: mdtest '-n' '1000' '-z' '3' '-b' '2' '-d' '/mnt/nbd/'
WARNING: Read bytes is 0, thus, a read test will actually just open/close
Path                : /mnt/nbd/
WARNING: Read bytes is 0, thus, a read test will actually just open/close
FS                  : 135.5 GiB   Used FS: 26.4%   Inodes: 17.2 Mi   Used Inodes: 2.9%
Nodemap: 11
2 tasks, 1980 files/directories

SUMMARY rate: (of 1 iterations)
   Operation                     Max            Min           Mean        Std Dev
   ---------                     ---            ---           ----        -------
   Directory creation          41694.767      41694.767      41694.767          0.000
   Directory stat             734411.206     734411.206     734411.206          0.000
   Directory rename            33748.606      33748.606      33748.606          0.000
   Directory removal           66777.003      66777.003      66777.003          0.000
   File creation               59198.086      59198.086      59198.086          0.000
   File stat                  502646.285     502646.285     502646.285          0.000
   File read                  140306.165     140306.165     140306.165          0.000
   File removal                67342.317      67342.317      67342.317          0.000
   Tree creation               36684.875      36684.875      36684.875          0.000
   Tree removal                 6019.380       6019.380       6019.380          0.000
-- finished at 07/20/2025 12:59:53 --
```

### mdtest summary

| Operation   | EBS GP3 | FSx OpenZFS | FSx OpenZFS nconnect=16 | FSx OpenZFS nfsvers=3 | FSx OpenZFS vers=4.2 | FSx Lustre | ZeroFS NBD (10GB cache) |
| ----------- | ------- | ----------- | ----------------------- | --------------------- | -------------------- | ---------- | ----------------------- |
| Dir Create  | 42,309  | 1,322       | 1,214                   | 1,879                 | 1,219                | 2,820      | 41,695                  |
| Dir Stat    | 748,915 | 24,153      | 24,616                  | 504,203               | 90,119               | 4,631      | 734,411                 |
| Dir Rename  | 37,824  | 1,108       | 1,057                   | 1,130                 | 1,170                | 1,040      | 33,749                  |
| Dir Remove  | 54,682  | 1,291       | 1,260                   | 2,357                 | 1,682                | 1,729      | 66,777                  |
| File Create | 60,179  | 986         | 995                     | 834                   | 1,031                | 1,911      | 59,198                  |
| File Stat   | 476,188 | 473,230     | 458,977                 | 505,000               | 476,079              | 3,084      | 502,646                 |
| File Read   | 143,730 | 1,872       | 2,076                   | 3,253                 | 2,167                | 2,533      | 140,306                 |
| File Remove | 87,556  | 1,461       | 1,535                   | 1,672                 | 1,606                | 1,331      | 67,342                  |
| Tree Create | 39,053  | 829         | 776                     | 596                   | 848                  | 1,644      | 36,685                  |
| Tree Remove | 7,941   | 1,101       | 1,118                   | 1,140                 | 1,105                | 2,773      | 6,019                   |

Note: Rates are operations per second. Test: 2 MPI tasks, 1000 files/directories each (1980 total), depth 3, branching factor 2
