# redis

Connect to tls host:

```
redis-cli -h myredis.com --tls
```

test redis-py ssl:

```python
host = "myredis.com"
port = 6379

import socket
import ssl
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
context = ssl.create_default_context()
sock.connect((host, port))
# server_hostname used for certificate validation
ssl_sock = context.wrap_socket(sock, server_hostname=host)
```
