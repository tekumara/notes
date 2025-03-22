# moto

In the moto docs "motoapi.amazonaws.com" is not a real host name, it's a placeholder when using non-server mode. For server mode, replace with localhost:port.

By default moto runs on port 5000 but this is already consumed by Airplay on macos so you'll want to choose a different port.

To reset the account between test use the reset API, eg:

```python
requests.post(f"{moto.endpoint_url}/moto-api/reset")
```

See [multi-account support](https://docs.getmoto.org/en/latest/docs/multi_account.html) if you want to isolate each test to a different account.
