# Netcat

Start ngrok

```
ngrok tcp --region=au 8888
```

Listen on port 8888 (macOSX):

```
nc -l localhost 8888
```

Connect to ngrok

```
nc 0.tcp.au.ngrok.io 16344
```

## Copy a file

Start a netcat listening on the source:
`nc -l <port> < myfile`

Receive it on the destination:
`nc <host> <port> > myfile`

Or, if client is linux without netcat installed:
`cat < /dev/tcp/<ip>/<port> > myfile`

[Ref](http://unix.stackexchange.com/questions/49936/dev-tcp-listen-instead-of-nc-listen)
