# aws bedrock

## cli

List all models, including ones you don't have access to:

```
aws bedrock list-foundation-models | jq -r '.modelSummaries[].modelId'
```

See also this [list of models by region](https://docs.aws.amazon.com/bedrock/latest/userguide/models-regions.html).

## boto

```python
import boto3
bedrock_client = boto3.client(
 service_name='bedrock-runtime',
 region_name='us-east-1')
bedrock_client
output_text = bedrock_client.list_foundation_models()
print(output_text)
```

```python
import boto3, json
from botocore.config import Config
config = Config(read_timeout=2, retries={"total_max_attempts": 2})
client = boto3.client(service_name="bedrock-runtime", config=config)
prompt = "Human: foobar Assistant:"
response = client.invoke_model(modelId="anthropic.claude-instant-v1",body=json.dumps({"prompt":prompt, "max_tokens_to_sample":300}))
json.loads(response.get("body").read())
```

Response headers:

```
{'Date': 'Thu, 01 Feb 2024 11:32:07 GMT', 'Content-Type': 'application/json', 'Content-Length': '224', 'Connection': 'keep-alive', 'x-amzn-RequestId': 'ea293f49-1509-4c7a-9acf-cb195c166d1b', 'X-Amzn-Bedrock-Invocation-Latency': '1328', 'X-Amzn-Bedrock-Output-Token-Count': '34', 'X-Amzn-Bedrock-Input-Token-Count': '11'}
```

## marketplace subscriptions

- "c468b48a-84df-43a4-8c46-8870630108a7" Claude (12K) (Amazon Bedrock Edition)
- "99d90be8-b43e-49b7-91e4-752f3866c8c7" Claude (100K) (Amazon Bedrock Edition)
- "b0eb9475-3a2c-43d1-94d3-56756fd43737" Claude Instant (12K) (Amazon Bedrock Edition)
- "1d288c71-65f9-489a-a3e2-9c7f4f6e6a85" Jurassic-2 Mid (Amazon Bedrock Edition)
- "cc0bdd50-279a-40d8-829c-4009b77a1fcc" Jurassic-2 Ultra (Amazon Bedrock Edition)
- "d0123e8d-50d6-4dba-8a26-3fed4899f388" SDXL Beta V0.8 (Amazon Bedrock Edition)

## agents

Scope: tool use + RAG + chat history.

- [Data sources](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent_CreateDataSource.html) - S3. Can configure [fixed size chunking with overlap](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent_ChunkingConfiguration.html).
- Knowledge bases (ie: data stores) - OpenSearch Serverless, Pinecone, Amazon Aurora, Redis Enterprise Cloud
  LLMs - Bedrock.
- [Sessions](https://docs.aws.amazon.com/bedrock/latest/userguide/advanced-prompts.html) - supports conversation history and multiple turns.
- [Prompt templates](https://docs.aws.amazon.com/bedrock/latest/userguide/advanced-prompts.html).
- [Monitoring - Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/model-invocation-logging.html)

See more at the [Agents for Bedrock API](https://docs.aws.amazon.com/bedrock/latest/userguide/advanced-prompts.html)

## bedrock knowledge bases

- [natural language to sql](https://aws.amazon.com/about-aws/whats-new/2024/12/amazon-bedrock-knowledge-bases-structured-data-retrieval/)
- [graphRAG](https://aws.amazon.com/about-aws/whats-new/2024/12/amazon-bedrock-knowledge-bases-graphrag-preview/)

## agentcore

- serverless runtime
- identify for secure tool access
- memory
- tools: browser, code interpreter
- [gateway](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway.html) - MCP-ify Lambda and other APIs without hosting anything
- observability
- any LLM

See [Bedrock AgentCore Starter Toolkit](https://github.com/aws/bedrock-agentcore-starter-toolkit)
