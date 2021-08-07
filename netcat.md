# Netcat

Listen on port 8888 (macOSX):

```
nc -l localhost 8888
```

Connect to port 25

```
nc myhost 25
```

Bidirectional forward from stdin/stdout to port 5556:

```
socat TCP4-LISTEN:5556,reuseaddr,fork EXEC:"aws ssm start-session --target %h --document-name AWS-StartSSHSession"
```

## Copy a file

Start netcat listening on the source:
`nc -l <port> < myfile`

Receive it on the destination:
`nc <host> <port> > myfile`

Or, if client is linux without netcat installed:
`cat < /dev/tcp/<ip>/<port> > myfile`

[Ref](http://unix.stackexchange.com/questions/49936/dev-tcp-listen-instead-of-nc-listen)
