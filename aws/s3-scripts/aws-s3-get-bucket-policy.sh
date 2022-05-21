#!/bin/bash

buckets=(
bucket1
bucket2
)

for b in "${buckets[@]}"
do
    echo \# $b
    aws s3api get-bucket-policy --bucket "$b" | jq -r '.Policy | fromjson'
done

