from wikipediaapi import Wikipedia

query = "What are some well known New Zealand songs?"

# corpus
wiki = Wikipedia('MusicLovingBot/0.0', 'en')
ernest = wiki.page('Ernest_Rutherford').text
connan = wiki.page('Connan_Mockasin').text

import torch.nn.functional as F
from sentence_transformers import SentenceTransformer

# embed
emb_model = SentenceTransformer("BAAI/bge-small-en-v1.5", device="0")
q_emb,ernest_emb,connan_emb = emb_model.encode([query,ernest,connan], convert_to_tensor=True)

# search
et = F.cosine_similarity(q_emb, ernest_emb, dim=0) # tensor(0.5315, device='cuda:0')
ct = F.cosine_similarity(q_emb, connan_emb, dim=0)  # tensor(0.7991, device='cuda:0')

# build prompt
prompt = f"""Answer the question with the help of the provided context.

## Context

{connan}

## Question

{query}"""

# generate
bedrock.invoke_model(body="prompt",modelId="anthropic.claude-instant-v1",accept="application/json", contentType="application/json")
