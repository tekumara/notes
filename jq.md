# jq

`.[]` - unwraps array into a list of elements eg: `[ {"name": "a"}, {"name": "b"} ] ==> {"name": "a"}\n{"name": "b"}`

`[ elements ]` - array construction. Elements can be a list, or any jq expression, including a pipeline, which are all collected into one array.

`to_entries` - splits object into an array, one object per key eg:`{"a": 1, "b": 2} ==> [{"key":"a", "value":1}, {"key":"b", "value":2}]`

`to_entries[]` - splits and unwraps, eg: `{"a": 1, "b": 2} ==> {"key":"a", "value":1}\n{"key":"b", "value":2}`

`to_entries[0].value` - to get the value of the first key in an object (useful when you don't know what the key is called or it can change)

Convert all key values pairs into rows, in a table with a header

```
echo '{"a": 1, "bbbbbbbbbbbbbb": 2}' | jq -r '["h1", "h2"], (to_entries[] | [.key, .value]) |@tsv' | column -t
h1              h2
a               1
bbbbbbbbbbbbbb  2
```

Select all the values for a given key from all objects in an array

```
echo '{"top" : [ { "snapshot":"A", "state": "1" }, { "snapshot":"B", "state": "2" }]}' | jq '.top[].snapshot'
"A"
"B"
```

Use -r to remove the quotes ([ref](https://github.com/stedolan/jq/wiki/FAQ)):

```
echo '{"top" : [ { "snapshot":"A", "state": "1" }, { "snapshot":"B", "state": "2" }]}' | jq -r '.top[].snapshot'
A
B
```

Choose an element in an array based on a key value, and return another one of it's keys:

```
echo '[ { "snapshot":"A", "state": "1" }, { "snapshot":"B", "state": "2" }]' | jq 'map(select(.snapshot == "A")) | .[0].state'
"1"
```

`jq -C` write out ANSI colours when piping (useful with less -R)

Only select elements that are a string, to filter out nulls

```
echo '[null,"something"]' | jq '.[] | strings'
"something"
```

Group by:

```
echo '[{"k":"a", "v":"one"}, {"k":"a", "v":"two"}, {"k":"b","v":"three"}]' | jq -c 'group_by(.k) | .[] | {k:.[0].k, v: [.[] | .v]}'
{"k":"a","v":[1,2]}
{"k":"b","v":[3]}
#  NB: [.[] | .v] = map(.v)
echo '[{"k":"a", "v":1}, {"k":"a", "v":2}, {"k":"b","v":3}]' | jq -c 'group_by(.k) | .[] | {k:.[0].k, v: map(.v)}'
{"k":"a","v":[1,2]}
{"k":"b","v":[3]}
```

Join (convert array to string):

```
echo '["one","two","three"]' | jq 'join("-")'
```

String interpolation:

```
echo 42 | jq '"The input was \(.), which is one less than \(.+1)"'
```

Select a value in an array of values and output as csv:

```
echo '[{"id": 1, "count":100}, {"id": 2, "count":200}, {"id": 3, "count":300}]' | jq -r 'map(select(.id == [1,3][])) | .[] | [.id, .count] | @csv'
1,100
3,300
```

Map over all fields, removing any with the key ".1" (useful for removing unnecessary verbose fields):

```
echo '{"a": { "1": "a1", "2": "a2" }, "b": { "1": "b1", "2": "b2" }, "c": { "1": "c1", "2": "c2" } }' | jq -c '. | map_values(del (."1"))'
{"a":{"2":"a2"},"b":{"2":"b2"},"c":{"2":"c2"}}
```

Counting the number of elements in a newline delimited json stream

- If the entire input file fits in memory, the simple solution is `jq -s length`. The -s flag puts everything in the input stream into one array before passing it to your program.
- If the input file is really big, use reduce to avoid reading everything into memory at once. This requires jq 1.5. `jq -n 'reduce inputs as $obj (0; .+1)'`

Select object with a key containing a string:

```
echo '[ { "name": "apple" }, { "name": "orange" }]' | jq '.[] | select(.name | contains("ran"))'
{
  "name": "orange"
}
```

Sort by key, input must be an array

```
echo '[ { "name": "banana" }, { "name": "apple" }]' | jq 'sort_by(.name)'
```

Sort json lines by key, by slurping them into an array first, and then converting back to elements:

```
printf '{ "name": "banana" }\n{ "name": "apple" }' | jq -s -c 'sort_by(.name)[]'
```

Convert date string to epoch timestamp

```
echo '[ { "name": "apple", "created_at": "Fri Jan 02 01:29:31 +0000 2020" }, { "name": "orange", "created_at": "Thu Nov 22 22:51:23 +0000 2019" }]' | jq '.[] .created_at |= (strptime("%a %b %d %H:%M:%S %z %Y")|mktime)
```

Sort date string chronologically descending

```
echo '[ { "name": "apple", "created_at": "Fri Jan 02 01:29:31 +0000 2020" }, { "name": "orange", "created_at": "Thu Nov 22 22:51:23 +0000 2019" }]' | jq 'sort_by(.created_at | strptime("%a %b %d %H:%M:%S %z %Y") | mktime) | reverse'
```

Extract python version using regex match

```
echo '["aec-cli-1.0.2.tar.gz","t1000-1.0.1-pre-proxyfix2.tar.gz","boto3-1.17.97.tar.gz","t1000-0.1.dev204+gc88c6ba.tar.gz","slimcontacts-1.2.4-CE-6.tar.gz"]' | jq '.[] | (capture("-(?<version>[0-9.]+[-+a-zA-Z0-9]*).tar.gz").version)'
```

Convert json string to json

echo '"{\"Version\":\"2012-10-17\"}"' | jq -r '. | fromjson'

## Refs

https://github.com/stedolan/jq/wiki/Cookbook

