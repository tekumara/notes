# ngrok

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

Forward VNC in Github Actions:

```
curl https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz | tar xvz -C /usr/local/bin
ngrok config add-authtoken <token>
# run in background
ngrok tcp --region=au 5900 --log=stdout > ngrok.log &
```
