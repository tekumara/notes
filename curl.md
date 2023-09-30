# Curl

## Usage

`-o/--output <file>` Write output to `<file>` instead of stdout
`-O` write to local file using name extracted from the URL
`-s/--silent` Silent or quiet mode. Don’t show progress meter or error messages. Makes curl mute.  
`-w <format>` write out the following

- `%{time_total}` time until the transfer completed, in secs
- `%{size_download}` size of the response (header and body), in bytes

`-v` show request and response headers  
`-L` follow location redirects  
`-f` on server errors, fail silently with no output and exit code 22
`-S` when used with `-s` show an error message if curl fails
`--connect-timeout <fractional seconds>` connection timeout (defaults to 75 secs)
`-m or --max-time <fractional seconds>` max time for transfer

[man page](http://curl.haxx.se/docs/manpage.html)

## Examples

Measure time to access URL

```bash
curl -s -o /dev/null -w %{time_total} http://google.com
```

Measure time and size of URL response

```bash
curl -s -o /dev/null -w "HTTP status code: %{http_code} Time: %{time_total} Size: %{size_download}\n" http://google.com
```

Create a POST query, and send form data in the body as Content-Type application/x-www-form-urlencoded

```bash
curl -d "q=conditions_search:brain" http://lime:8983/solr/baselineConditions/select
```

Create a POST query, and send form data in the body as Content-Type multipart/form-data. Use stdin for the contents of the field text (press CTRL-D twice to end stdin):

```bash
curl -F "text=<-" http://localhost:8090/debug/termExtraction
```

Create a POST query, with a JSON body:

```bash
curl -H "Content-Type: application/json" -X POST --data '{"logs":{"flow_run_id":{"any_":["b6b2e565-8e4b-4e24-b415-0cde3810fdb4"]},"level":{"ge_":0}},"sort":"TIMESTAMP_ASC"}' -s "http://localhost:4200/api/logs/filter"
```

From stdin with bearer token:

```bash
echo 123 |
  jq -c '{"query": { "match": { "number": . } } }' |
  curl -s -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d @- -XPOST url.com
```

Create a POST query, and send body from a file as Content-Type application/json

```bash
curl -v --data-binary @/storage/jd.json -H "Content-Type: application/json" http://localhost:8080/predict
```

Diff two JSON responses

```bash
diff <(curl -s "http://localhost:8080/search?query=plumbers" | jq) <(curl -s "http://localhost:8090/search?query=plumbers" | jq)
```

Post with no data

```bash
curl -X POST http://example.com
```

Error handling

```bash
function die() {
    >&2 echo -e $1
    exit 1
}
curl -f -s -d "$id_params" "$admin_url" --write-out "%{http_code}" || die "$admin_url failed"
```

Basic auth, password:

```bash
curl -u user:pass https://protected.url
```

## Script Usage

When running in a script disable the progress bar, show errors, set error exit code, and follow redirects:

```
curl -fsSL myapp | sh
```

When downloading a file in a script, using the name in the URL:

```
curl -fsSLO "https://myapp.net/myapp.tar.gz"
```

Or specify your own file name

```
curl -fsSLo archive.gz "https://myapp.net/myapp.tar.gz"
```

## Detailed timings

To see detailed timings, including time to first byte (ie: `time_starttransfer`) create the following file `curl-format.txt`:

```bash
time_namelookup: %{time_namelookup}\n
time_connect: %{time_connect}\n
time_appconnect: %{time_appconnect}\n
time_pretransfer: %{time_pretransfer}\n
time_redirect: %{time_redirect}\n
time_starttransfer: %{time_starttransfer}\n
———\n
time_total: %{time_total}
```

`\n` is needed above to create newlines. To execute:

```bash
curl -w "@curl-format.txt" -o /dev/null -s http://wordpress.com/
```

[ref](https://josephscott.org/archives/2011/10/timing-details-with-curl/)

## HTTP2

```
curl -v -k --raw --http2 -XPOST http://localhost:10001/ray.rpc.RayletDriver/ClusterInfo
*   Trying 127.0.0.1:10001...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 10001 (#0)
> POST /ray.rpc.RayletDriver/ClusterInfo HTTP/1.1
> Host: localhost:10001
> User-Agent: curl/7.68.0
> Accept: */*
> Connection: Upgrade, HTTP2-Settings
> Upgrade: h2c
> HTTP2-Settings: AAMAAABkAARAAAAAAAIAAAAA
>
* Received HTTP/0.9 when not allowed
```

```
curl -v -k --raw --http2-prior-knowledge -XPOST http://localhost:10001/ray.rpc.RayletDriver/ClusterInfo
*   Trying 127.0.0.1:10001...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 10001 (#0)
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x564d531dc8c0)
> POST /ray.rpc.RayletDriver/ClusterInfo HTTP/2
> Host: localhost:10001
> user-agent: curl/7.68.0
> accept: */*
>
```
