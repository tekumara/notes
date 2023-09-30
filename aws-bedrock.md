# aws bedrock

## usage

```
import boto3
bedrock_client = boto3.client(
 service_name='bedrock',
 region_name='us-east-1')
bedrock_client
output_text = bedrock_client.list_foundation_models()
print(output_text)
```

## marketplace subscriptions

- "c468b48a-84df-43a4-8c46-8870630108a7" Claude (12K) (Amazon Bedrock Edition)
- "99d90be8-b43e-49b7-91e4-752f3866c8c7" Claude (100K) (Amazon Bedrock Edition)
- "b0eb9475-3a2c-43d1-94d3-56756fd43737" Claude Instant (12K) (Amazon Bedrock Edition)
- "1d288c71-65f9-489a-a3e2-9c7f4f6e6a85" Jurassic-2 Mid (Amazon Bedrock Edition)
- "cc0bdd50-279a-40d8-829c-4009b77a1fcc" Jurassic-2 Ultra (Amazon Bedrock Edition)
- "d0123e8d-50d6-4dba-8a26-3fed4899f388" SDXL Beta V0.8 (Amazon Bedrock Edition)
