#!/bin/bash

buckets=(
bucket-to-delete-1
)

for b in "${buckets[@]}"
do
    echo \# $b
    read -r -d '' CONFIG << EOM
    {
        "Rules": [
            {
                "Expiration": {
                    "Days": 1
                },
                "ID": "delete-all",
                "Filter": {},
                "Status": "Enabled"
            }
        ]
    }
EOM
    aws s3api put-bucket-lifecycle-configuration --bucket "$b" --lifecycle-configuration "$CONFIG"
done

