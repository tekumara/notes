# Network monitoring

## Histograms

Histogram of connection states

```
netstat -tan | awk '{print $6}' | sort | uniq -c
      1 established)
     51 ESTABLISHED
      5 FIN_WAIT1
     13 FIN_WAIT2
      1 Foreign
     10 LISTEN
   5377 TIME_WAIT
```

Histogram of connection states to a given host/post:

```
netstat -tan | grep 127.0.0.1:8080 | awk '{print $6}' | sort | uniq -c
```

## Connections

All internet connections sorted by state

`netstat --inet -pa | sort -k6`

All internet connections with hostname and process

`netstat --inet -pa`

Established internet connections with IP and process

`netstat --inet -pn`

Continuously by process

`while sleep 1; do date;sudo netstat -tanp | grep java; done`

## ss

Similar to netstat, but supports filters.

To inspect listening TCP connections & queues on port 8080

```
while sleep 1; do date;ss -l -t -n 'sport = :8080'; done
```

To inspect established TCP connections & queues

```
while sleep 1; do date;ss -t -n; done
```

Connections to AWS S3 (ap-southeast-2)

```
ss -nt dst 52.92.52.0/22 or dst 52.95.128.0/21 or dst 54.231.248.0/22 or dst 54.231.252.0/24
```

The above CIDR ranges are from:

```
curl -s https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes[] | select(.service=="S3" and .region=="ap-southeast-2") | .ip_prefix'`
```

## To see what processes are open on what ports

List open internet ports (-i) showing port numbers instead of names (-P) and including other user-owned processes (hence sudo)
`sudo lsof -i -P`

To see only internet connections for PID 1234
`sudo lsof -p 1234 -i -a`

To see what user-owned process is listening on port 8080
`sudo lsof -iTCP:8080 -sTCP:LISTEN`

## nethogs (usage by process)

[nethogs](https://github.com/raboof/nethogs) shows cumulative totals and current throughput by process.

Press 'm' whilst running to toggle between cumulative and current throughput.

## iftop (usage by host)

[iftop](http://ex-parrot.com/~pdw/iftop/) shows usage by host.

Press 'T' to show cumulative totals.

## iptraf

Like iftop, but a little less useful.

## bandwhich

[bandwhich](https://github.com/imsnif/bandwhich) shows throughput by process and host 
