# jq

`.[]` - unwraps array into a list of elements eg: `[ {"name": "a"}, {"name": "b"} ] ==> {"name": "a"}\n{"name": "b"}`

`[ elements ]` - array construction. Elements can be a list, or any jq expression, including a pipeline, which are all collected into one array.

`to_entries` - splits object into an array, one object per key eg:`{"a": 1, "b": 2} ==> [{"key":"a", "value":1}, {"key":"b", "value":2}]`

`to_entries[]` - splits and unwraps, eg: `{"a": 1, "b": 2} ==> {"key":"a", "value":1}\n{"key":"b", "value":2}`

`to_entries[0].value` - to get the value of the first key in an object (useful when you don't know what the key is called or it can change)

Convert all key values pairs into rows, in a table with a header

```json
echo '{"a": 1, "bbbbbbbbbbbbbb": 2}' | jq -r '["h1", "h2"], (to_entries[] | [.key, .value]) |@tsv' | column -t
h1              h2
a               1
bbbbbbbbbbbbbb  2
```

Select all the values for a given key from all objects in an array

```json
echo '{"top" : [ { "snapshot":"A", "state": "1" }, { "snapshot":"B", "state": "2" }]}' | jq '.top[].snapshot'
"A"
"B"
```

Use -r to remove the quotes ([ref](https://github.com/stedolan/jq/wiki/FAQ)):

```json
echo '{"top" : [ { "snapshot":"A", "state": "1" }, { "snapshot":"B", "state": "2" }]}' | jq -r '.top[].snapshot'
A
B
```

Select specific keys from objects in array:

```
echo ' [ {"a": 1, "b": 2}, {"a": 3, "b": 4} ] ' | jq '[ .[]| {a} ]'
[
  {
    "a": 1
  },
  {
    "a": 3
  }
]
```

Choose an element in an array based on a key value, and return another one of it's keys:

```json
echo '[ { "snapshot":"A", "state": "1" }, { "snapshot":"B", "state": "2" }]' | jq 'map(select(.snapshot == "A")) | .[0].state'
"1"
```

map isn't needed if the array is unwrapped eg:

```
❯ echo '[ { "snapshot":"A", "state": "1" }, { "snapshot":"B", "state": "2" }]' | jq '.[] | select(.snapshot == "A") | .state'
"1"
```

Example using terraform state and a jq arg (variable)

```
cat /tmp/tfstate | jq --arg module "module.$repo" '.resources[] | select(.module == $module and .type == "github_repository") | .instances[0].attributes | {merge_commit_message,merge_commit_title, etag}'
```

`jq -C` write out ANSI colours when piping (useful with less -R)

Only select elements that are a string, to filter out nulls

```json
echo '[null,"something"]' | jq '.[] | strings'
"something"
```

Group by:

```json
echo '[{"k":"a", "v":"one"}, {"k":"a", "v":"two"}, {"k":"b","v":"three"}]' | jq -c 'group_by(.k) | .[] | {k:.[0].k, v: [.[] | .v]}'
{"k":"a","v":[1,2]}
{"k":"b","v":[3]}
#  NB: [.[] | .v] = map(.v)
echo '[{"k":"a", "v":1}, {"k":"a", "v":2}, {"k":"b","v":3}]' | jq -c 'group_by(.k) | .[] | {k:.[0].k, v: map(.v)}'
{"k":"a","v":[1,2]}
{"k":"b","v":[3]}
```

Join (convert array to string):

```json
echo '["one","two","three"]' | jq 'join("-")'
```

String interpolation:

```json
echo 42 | jq '"The input was \(.), which is one less than \(.+1)"'
```

Select object in array by key not containing a string:

```json
echo '[ { "name": "apple" }, { "name": "orange" }]' | jq '.[] | select(.name | contains("ran") | not)'
{
  "name": "orange"
}
```

Select a value in an array using map and output as csv:

```json
echo '[{"id": 1, "count":100}, {"id": 2, "count":200}, {"id": 3, "count":300}]' | jq -r 'map(select(.id == [1,3][])) | .[] | [.id, .count] | @csv'
1,100
3,300
```

Map over all fields, removing any with the key ".1" (useful for removing unnecessary verbose fields):

```json
echo '{"a": { "1": "a1", "2": "a2" }, "b": { "1": "b1", "2": "b2" }, "c": { "1": "c1", "2": "c2" } }' | jq -c '. | map_values(del (."1"))'
{"a":{"2":"a2"},"b":{"2":"b2"},"c":{"2":"c2"}}
```

Counting the number of elements in a newline delimited json stream

- If the entire input file fits in memory, the simple solution is `jq -s length`. The -s flag puts everything in the input stream into one array before passing it to your program.
- If the input file is really big, use reduce to avoid reading everything into memory at once. This requires jq 1.5. `jq -n 'reduce inputs as $obj (0; .+1)'`

Sort by key, input must be an array

```json
echo '[ { "name": "banana" }, { "name": "apple" }]' | jq 'sort_by(.name)'
```

Sort json lines by key, by slurping them into an array first, and then converting back to elements:

```json
printf '{ "name": "banana" }\n{ "name": "apple" }' | jq -s -c 'sort_by(.name)[]'
```

To sort by array element, wrap in an outer array:

``json
echo '[[3,4],[5,2]]' | jq 'sort_by(.[1])[]'

````

Convert date string to epoch timestamp

```json
echo '[ { "name": "apple", "created_at": "Fri Jan 02 01:29:31 +0000 2020" }, { "name": "orange", "created_at": "Thu Nov 22 22:51:23 +0000 2019" }]' | jq '.[] .created_at |= (strptime("%a %b %d %H:%M:%S %z %Y")|mktime)
````

Sort date string chronologically descending

```json
echo '[ { "name": "apple", "created_at": "Fri Jan 02 01:29:31 +0000 2020" }, { "name": "orange", "created_at": "Thu Nov 22 22:51:23 +0000 2019" }]' | jq 'sort_by(.created_at | strptime("%a %b %d %H:%M:%S %z %Y") | mktime) | reverse'
```

Extract python version using regex match

```json
echo '["aec-cli-1.0.2.tar.gz","t1000-1.0.1-pre-proxyfix2.tar.gz","boto3-1.17.97.tar.gz","t1000-0.1.dev204+gc88c612.tar.gz","contacts-1.2.4-CE-6.tar.gz"]' | jq '.[] | (capture("-(?<version>[0-9.]+[-+a-zA-Z0-9]*).tar.gz").version)'
```

Convert json string to json

```
echo '"{\"Version\":\"2012-10-17\"}"' | jq -r '. | fromjson'
```

Base64 decode:

```
jq '."moby.buildkit.cache.v0" | @base64d | fromjson' e5a6a0bb46d5ae24bf64f3a0a58b99d7cabcda46160f4be494639378505666d9.json
```

## Refs

- [Cookbook](https://github.com/stedolan/jq/wiki/Cookbook)
