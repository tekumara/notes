#!/bin/bash

set -euo pipefail

buckets=(
bucket1
bucket2
)

for b in "${buckets[@]}"
do
    aws s3api get-bucket-encryption --bucket "$b" | jq -r '.ServerSideEncryptionConfiguration.Rules[].ApplyServerSideEncryptionByDefault | [.SSEAlgorithm, .KMSMasterKeyID, "'"$b"'" ] | @tsv'
done
