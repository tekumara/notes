# aws FSx

## OpenZFS

Scale up, good for low latency.

Single AZ host. No durability guarantees.

Pricing (us-east-1):

- SSD storage capacity $0.09 per GB-month (uncompressed), eg: 100 GB = $9
- Throughput capacity $0.260 per MBps-month eg: 125 MB/s = $32.5
- SSD IOPS $0.0060 per IOPS-month, eg: 300 IOPS = $1.8

## Lustre

Scale out, good for high throughput.

Can be backed by S3, so has S3-level durability guarantees.

Perf based on data size, baseline 200MB/s see [Amazon FSx for Lustre Performance](https://docs.aws.amazon.com/fsx/latest/LustreGuide/performance.html)

Pricing (us-east-1):

- SSD Storage capacity 125 MB/s/TiB $0.145 per GB-month (uncompressed)

Because pricing is based on storage not usage, it scales across multiple machines.

## EFS

EFS bursts to 100 MiB/s
Not backed by S3.

Pricing (us-east-1):

- Standard Storage (GB-Month) $0.30
- Infrequent Access Storage (GB-Month) $0.025
- Infrequent Access Requests (per GB transferred) $0.01
- Provisioned Throughput (MB/s-Month) $6.00

## References

- [AWS re:Invent 2021 - {New Launch} Introducing Amazon FSx for OpenZFS](https://www.youtube.com/watch?v=hPJSIZD099o)
