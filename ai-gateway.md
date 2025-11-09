# ai gateway

cost control

- cost monitoring and alerts
- budgets that limit on dollar amount for non-prod

rate limiting based on

- TPM (tokens per minute)
- RPM (requests per minute)

byok (bring your key)

- support for multiple keys per provider (so we can map these to different openai projects)

api support

- open ai responses api support (including web search + params like verbosity)
- custom hosts, eg: routing to us.openai.com to keep requests in the US
- bedrock inference profile support (to benefit from larger quotas)
- streaming support
- image/document support (multi-modal)
- embeddings apis (eg: bedrock titan)

fallbacks

- based on success rate (and potentially latency)

performance

- negligible latency impact
