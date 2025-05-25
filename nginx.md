# nginx

## Troubleshooting

```
default backend - 404
```

Provide a Host header, eg:

```
curl -H "Host: myapi.org" http://...
```
