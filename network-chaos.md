# network chaos

## macos

Use i

## Simulate Postgres down (linux)

```
$ sudo iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
$ nc -v -w 5 localhost 5432
Connection to localhost 5432 port [tcp/postgresql] succeeded!
^C
$ sudo iptables -A OUTPUT -p tcp -m tcp --dport 5432 -j DROP
$ sudo iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A OUTPUT -p tcp -m tcp --dport 5432 -j DROP
$ nc -v -w 5 localhost 5432
nc: connect to localhost port 5432 (tcp) timed out: Operation now in progress
```
