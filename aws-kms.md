# aws kms

Describe key

```
aws kms describe-key --key-id arn:aws:kms:us-east-1:123456789012:key/569bba03-c7df-4d96-82e8-cc564ef91e66 | cat
```

Describe key via alias

```
aws kms describe-key --key-id arn:aws:kms:us-east-1:123456789012:alias/my-top-secret-key
```

List aliases in the _callers_ account

```
aws kms list-aliases
```

List grants

```
aws kms list-grants --key-id arn:aws:kms:us-east-1:123456789012:key/569bba03-c7df-4d96-82e8-cc564ef91e66
```

## Minimal policy for writing to S3

```
      - kms:Encrypt
      # needed for S3 client-side encryption, eg: when using a CMK
      - kms:GenerateDataKey
    Effect: Allow
```

## Default key policy

```
    - Effect: Allow
      Action:
        - kms:Encrypt
        - kms:Decrypt
        - kms:ReEncrypt*
        - kms:GenerateDataKey*
        - kms:DescribeKey
```

See [Allows key users to use the KMS key](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default-allow-users)

## Troubleshooting

com.amazonaws.services.kms.model.AWSKMSException: The ciphertext refers to a customer master key that does not exist, does not exist in this region, or you are not allowed to access.

The key policy does not grant your user/role access.

## References

- [Why are cross-account users getting Access Denied errors when they try to access S3 objects encrypted by a custom AWS KMS key?](https://aws.amazon.com/premiumsupport/knowledge-center/cross-account-access-denied-error-s3/)
