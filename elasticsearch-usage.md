<div title="Elastic Search Usage" creator="YourName" modifier="YourName" created="201606280323" modified="201709180548" tags="ElasticSearch" changecount="7">
<pre>!To start with debug
{{{
ES_JAVA_OPTS=&quot;-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005&quot; bin/elasticsearch
}}}

!To change the port
{{{
sed -i 's/#http.port: 9200/http.port: 9500\ntransport.tcp.port: 9600/' elasticsearch-5.1.1/config/elasticsearch.yml
}}}

!Index example

To create with randomly generated ID (ie: the _id field):
{{{
curl -XPOST 'http://localhost:9200/twitter/tweet/' -d '{
    &quot;user&quot; : &quot;kimchy&quot;,
    &quot;post_date&quot; : &quot;2009-11-15T14:12:12&quot;,
    &quot;message&quot; : &quot;random _id field&quot;
}'
}}}

To create with _id=1:
{{{
curl -XPUT 'http://localhost:9200/twitter/tweet/1' -d '{
    &quot;user&quot; : &quot;kimchy&quot;,
    &quot;post_date&quot; : &quot;2009-11-15T14:12:12&quot;,
    &quot;message&quot; : &quot;_id will be 1&quot;
}'
}}}

Count: {{{curl http://localhost:9200/twitter/tweet/_count}}}

Get: {{{curl http://localhost:9200/twitter/tweet/1}}}

!Bulk index example

{{{
curl -XPOST 'http://localhost:9200/twitter/tweet/_bulk' -d '{ &quot;index&quot; : { &quot;_id&quot; : &quot;1&quot; } }
{&quot;name&quot;:&quot;test1&quot;}
{ &quot;index&quot; : { &quot;_id&quot; : &quot;2&quot; } }
{&quot;name&quot;:&quot;test2&quot;}'
}}}

[[ref|https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html]]
</pre>
</div>
