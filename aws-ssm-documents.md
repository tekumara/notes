# AWS SSM Documents

Fetch document:

```
aws ssm get-document --name AWS-RunPatchBaseline --query 'Content' --output text > AWS-RunPatchBaseline.json
```

Extract PatchLinux run command from patch baseline:

```
jq -r '.mainSteps[] | select(.name == "PatchLinux") | .inputs.runCommand[]' AWS-RunPatchBaseline.json > patch-linux.sh
```

Extract script:

```
jq -r '.mainSteps[0] | .inputs.Script' AWS-RunPacker.json > runpacker.py
```

aws ssm describe-document --name AWS-StartSSHSession

```
{
    "Document": {
        "Hash": "5e61c6c179577705beb7aed532731078d4c5cf836abb4d695b0b0f7a7890b114",
        "HashType": "Sha256",
        "Name": "AWS-StartSSHSession",
        "Owner": "Amazon",
        "CreatedDate": "2019-06-13T07:33:03.766000+10:00",
        "Status": "Active",
        "DocumentVersion": "1",
        "Parameters": [
            {
                "Name": "portNumber",
                "Type": "String",
                "Description": "(Optional) Port number of SSH server on the instance",
                "DefaultValue": "22"
            }
        ],
        "PlatformTypes": [
            "Windows",
            "Linux",
            "MacOS"
        ],
        "DocumentType": "Session",
        "SchemaVersion": "1.0",
        "LatestVersion": "1",
        "DefaultVersion": "1",
        "DocumentFormat": "JSON",
        "Tags": []
    }
}
```

cat StandardStream.json

```
{
  "schemaVersion": "1.0",
  "description": "Session Document Example JSON Template",
  "sessionType": "Standard_Stream",
  "inputs": {
    "s3BucketName": "",
    "s3KeyPrefix": "",
    "s3EncryptionEnabled": true,
    "cloudWatchLogGroupName": "",
    "cloudWatchEncryptionEnabled": true,
    "kmsKeyId": "",
    "runAsEnabled": false
  }
}
```

aws ssm create-document \
 --name Standard_Stream \
 --content "file://StandardStream.json" \
 --document-type "Session" \
 --document-format JSON

```
{
    "DocumentDescription": {
        "Hash": "672972712081ad5355f6fe1e4bdb42960db3c11bf299c732b028fe1ea695e831",
        "HashType": "Sha256",
        "Name": "Standard_Stream",
        "Owner": "608685560404",
        "CreatedDate": "2021-05-22T21:13:30.048000+10:00",
        "Status": "Creating",
        "DocumentVersion": "1",
        "PlatformTypes": [
            "Windows",
            "Linux",
            "MacOS"
        ],
        "DocumentType": "Session",
        "SchemaVersion": "1.0",
        "LatestVersion": "1",
        "DefaultVersion": "1",
        "DocumentFormat": "JSON",
        "Tags": []
    }
}
```
