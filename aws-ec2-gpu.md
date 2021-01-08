# aws gpus

| instance   | mem       | cpu      | gpu           | cost (us-east-1) | notes                 |
| ---------- | --------- | -------- | ------------- | ---------------- | --------------------- |
| p2.xlarge  | 61.0 GiB  | 4 vCPUs  | 1 GPU (K80)   | \$0.90 / hour    | Basic GPU instance    |
| p2.8xlarge | 488.0 GiB | 32 vCPUs | 8 GPUs (K80)  | \$7.20 / hour    |                       |
| p3.2xlarge | 61.0 GiB  | 8 vCPUs  | 1 GPU (V100)  | \$3.06 / hour    | Latest gen GPU (V100) |
| p3.8xlarge | 244.0 GiB | 32 vCPUs | 4 GPUs (V100) | \$12.24 / hour   |                       |

K80 is 1.87+ TFLOPS
V100 is 7 ~ 7.8 TFLOPS ie: 3-4x
