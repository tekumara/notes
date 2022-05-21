#!/bin/bash

buckets=(
bucket1
bucket2
)

for b in "${buckets[@]}"
do
    echo \# $b
    aws s3api get-bucket-encryption --bucket "$b" | jq -r '.ServerSideEncryptionConfiguration.Rules[].ApplyServerSideEncryptionByDefault | [.SSEAlgorithm, .KMSMasterKeyID] | @tsv'
done
