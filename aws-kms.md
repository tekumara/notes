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

## Grant cross-account access to a key for decryption

```
              - kms:Decrypt
              - kms:GenerateDataKey
              - kms:DescribeKey
            Effect: Allow
```

[ref](https://aws.amazon.com/premiumsupport/knowledge-center/cross-account-access-denied-error-s3/)


## Troubleshooting

com.amazonaws.services.kms.model.AWSKMSException: The ciphertext refers to a customer master key that does not exist, does not exist in this region, or you are not allowed to access.

The key policy does not grant your user/role access.
