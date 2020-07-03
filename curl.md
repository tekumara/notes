Options:

{{{-O}}} write the output to a file in the current directory, using a filename extracted from the url.

{{{-o/--output <file>}}}
              Write  output  to  <file>  instead  of stdout

{{{-s/--silent}}}
              Silent or quiet mode. Don’t show progress meter or error messages.  Makes Curl mute.

{{{-w <format>}}} write out the following
     %{time_total} time until the transfer completed, in secs
     %{size_download} size of the response (header and body), in bytes

{{{-v}}} show request and response headers

{{{-L}}} follow location redirects

{{{-f}}}
     on server errors, fail silently with no output and exit code 22

eg:

Measure time to access URL 
{{{
curl -s -o /dev/null -w %{time_total} http://google.com
}}}

Measure time and size of URL response
{{{
curl -s -o /dev/null -w "HTTP status code: %{http_code} Time: %{time_total} Size: %{size_download}\n" http://google.com
}}}

Create a POST query, and send form data in the body as Content-Type application/x-www-form-urlencoded
{{{
curl -d "q=conditions_search:brain" http://lime:8983/solr/baselineConditions/select
}}}

Create a POST query, and send form data in the body as Content-Type multipart/form-data. Use stdin for the contents of the field text (press CTRL-D twice to end stdin):
{{{
curl -F "text=<-" http://localhost:8090/debug/termExtraction
}}}


Create a POST query, and send body from a file as Content-Type application/json
{{{
curl -v --data-binary @/storage/jd.json -H "Content-Type: application/json" http://localhost:8080/predict
}}}



Diff two JSON responses
{{{
diff <(curl -s "http://localhost:8080/search?query=plumbers" | python -m json.tool) <(curl -s "http://localhost:8090/search?query=plumbers" | python -m json.tool)
}}}

Post with no data
{{{
curl -X POST http://example.com
}}}

[[Cool ways to Diff two HTTP Requests in your terminal!|https://gist.github.com/Nijikokun/d6606c036d89d3b1574c]]

Error handling
{{{
function die() {
    >&2 echo -e $1
    exit 1
}
curl -f -s -d "$id_params" "$admin_url" --write-out "%{http_code}" || die "$admin_url failed"
}}}


Basic auth, password on command line:
{{{
curl -u user:pass https://protected.url
}}}

[[man page|http://curl.haxx.se/docs/manpage.html]]

!Detailed timings

To see detailed timings, including time to first byte (ie: time_starttransfer) create the following file {{{curl-format.txt}}}:
{{{
time_namelookup: %{time_namelookup}\n
time_connect: %{time_connect}\n
time_appconnect: %{time_appconnect}\n
time_pretransfer: %{time_pretransfer}\n
time_redirect: %{time_redirect}\n
time_starttransfer: %{time_starttransfer}\n
———\n
time_total: %{time_total}
}}}
Then:
{{{curl -w "@curl-format.txt" -o /dev/null -s http://wordpress.com/}}}

[[ref|https://josephscott.org/archives/2011/10/timing-details-with-curl/]]
