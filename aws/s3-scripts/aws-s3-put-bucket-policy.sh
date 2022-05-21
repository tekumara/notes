#!/bin/bash

buckets=(
bucket-to-deny-access-1
bucket-to-deny-access-2
)

for b in "${buckets[@]}"
do
    echo \# $b
    read -r -d '' POLICY << EOM
    {
        "Version": "2012-10-17",
        "Id": "Policy1619743014342",
        "Statement": [
            {
                "Sid": "Stmt1619743011846",
                "Effect": "Deny",
                "Principal": {
                    "AWS": "*"
                },
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::$b/*"
            }
        ]
    }
EOM
    aws s3api get-bucket-policy --bucket "$b"
    echo $POLICY
    aws s3api put-bucket-policy --bucket "$b" --policy "$POLICY"
done

