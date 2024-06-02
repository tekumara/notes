# vespa

## Proton

Vespa's search core written in C++.

Per document type/schema maintains:

- [Document store](https://docs.vespa.ai/en/proton.html#document-store) - compressed version of the original source document, aka `summary`.
- [Index](https://docs.vespa.ai/en/proton.html#index) - dictionary and posting lists (aka inverted index), with position, for [full-text search](https://docs.vespa.ai/en/text-matching.html) over strings with stemming, normalisation and other [linguistic processing](https://docs.vespa.ai/en/linguistics.html) applied. Recent index updates go into an [in-memory B-tree](https://docs.vespa.ai/en/partial-updates.html#write-pipeline). In-memory B-tree updates reduce the workload when [merging with disk indices](https://docs.vespa.ai/en/proton.html#disk-index-fusion) and enable low-latency updates that are immediately visible without needing to create lots of tiny segments that increase the merge workload (cf. [refresh=true in Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-refresh.html#_choosing_which_setting_to_use)) and therefore tail latency. Additional this architecture allows effective [partial updates](https://docs.vespa.ai/en/partial-updates.html) at scale ([50k numeric updates per second](https://blog.vespa.ai/the-great-search-engine-debate-elasticsearch-solr-or-vespa/#:~:text=Vespa%20can%20do%2050%2C000%20numeric%20partial%20updates%20per%20second%20per%20node)).
- [Attributes](https://docs.vespa.ai/en/attributes.html) - for structured data other than text search, used in matching, ranking, or grouping. An [array](https://github.com/vespa-engine/vespa/issues/5434#issuecomment-378614858) with one entry per document, unless [fast-search](https://docs.vespa.ai/en/attributes.html#index-structures) is used for faster lookup (but uses more memory). Reside in memory by default but can be [paged](https://docs.vespa.ai/en/attributes.html#paged-attributes) from disk.

References

- [github #8994](https://github.com/vespa-engine/vespa/issues/8994#issuecomment-486172487)
- [github #5434 comment](https://github.com/vespa-engine/vespa/issues/5434#issuecomment-378614858) and [this one](https://github.com/vespa-engine/vespa/issues/5434#issuecomment-380429972)
- [Vespa is optimized for low-latency updates](https://blog.vespa.ai/migrating-to-the-vespa-search-engine/#:~:text=Vespa%20is%20optimized%20for%20low%2Dlatency%20updates)
- [Vespa moved away from indexing architecture similar to Elasticsearch and Solr](https://blog.vespa.ai/the-great-search-engine-debate-elasticsearch-solr-or-vespa/#:~:text=Vespa%20moved%20away%20from%20indexing%20architecture%20similar%20to%20Elasticsearch%20and%20Solr)

> Attributes may optionally have fast-search specified, in which case an in-memory B-tree is maintained over the data.

## Tensors

Vespa supports tensor operations natively.

References

- [Scaling Recommenders systems with Vespa](https://medium.com/farfetch-tech-blog/scaling-recommenders-systems-with-vespa-9c62a0cc978a)

## Embedding flexibility

- Text in text out, ie: let Vespa do the embedding for you using any ONNX model
- [Multiple vectors per doc](https://blog.vespa.ai/semantic-search-with-multi-vector-indexing/), that can be used for either retrieval or ranking
- Support for binary vectors with the hamming distance metric (not yet supported by Elasticsearch)

References

- [Embedding flexibility in Vespa](https://blog.vespa.ai/embedding-flexibility-in-vespa/)
- [To chunk or not to chunk](https://blog.vespa.ai/rag-perspectives/#to-chunk-or-not-to-chunk)
- [Ability to index (hnsw) multiple vector points per document #15854](https://github.com/vespa-engine/vespa/issues/15854)

## Streaming mode

For working with naturally sharded data

References

- [Vector streaming search: AI assistants at scale without breaking the bank](https://medium.com/vespa/vector-streaming-search-ai-assistants-at-scale-without-breaking-the-bank-b7e6e858c8d1)
- [Turbocharge RAG with LangChain and Vespa Streaming Mode for Sharded Data](https://blog.vespa.ai/turbocharge-rag-with-langchain-and-vespa-streaming-mode/)

## Phased ranking

https://docs.vespa.ai/en/phased-ranking.html

## Data distribution

No need to manually partition data. Distribution based on CRUSH algorithm. Maintains replication factor.
You don’t have to pre-determine the number of shards, and [can add nodes at any time](https://blog.vespa.ai/the-great-search-engine-debate-elasticsearch-solr-or-vespa/).

References

- [Content Cluster Elasticity](https://docs.vespa.ai/en/elasticity.html)

## Declarative deployment

Via application packages

## Hot swap

- Can hot swap embeddings for the same document whilst its been updated using reindexing
