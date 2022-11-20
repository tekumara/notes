# Elastic Search Usage

## Running

Start with debug

```
ES_JAVA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005" bin/elasticsearch
```

Change the port

```
sed -i 's/#http.port: 9200/http.port: 9500\ntransport.tcp.port: 9600/' elasticsearch-5.1.1/config/elasticsearch.yml
```

## Queries

Count

```
curl http://localhost:9200/twitter/tweet/_count
```

Get

```
curl http://localhost:9200/twitter/tweet/1
```

Cluster health

```
curl http://localhost:9200/_cluster/health
```

Search

```
curl -XPOST -H 'Content-Type: application/json' http://localhost:9200/_search -d '
```

## Indexing

To create with randomly generated ID (ie: the \_id field):

```
curl -XPOST 'http://localhost:9200/twitter/tweet/' -d '{
    "user" : "kimchy",
    "post_date" : "2009-11-15T14:12:12",
    "message" : "random _id field"
}'
```

To create with \_id=1:

```
curl -XPUT 'http://localhost:9200/twitter/tweet/1' -d '{
    "user" : "kimchy",
    "post_date" : "2009-11-15T14:12:12",
    "message" : "_id will be 1"
}'
```

Bulk index example

```
curl -XPOST 'http://localhost:9200/twitter/tweet/_bulk' -d '{ "index" : { "_id" : "1" } }
{"name":"test1"}
{ "index" : { "_id" : "2" } }
{"name":"test2"}'
```

[Index API docs](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html)
