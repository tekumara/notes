# code server

## macOS

brew install code-server
brew services start code-server

Now visit http://127.0.0.1:8080. Your password is in ~/.config/code-server/config.yaml

## ubuntu

Install:

```
curl -fsSL https://code-server.dev/install.sh | sh -s --
sudo systemctl enable --now code-server@$USER

# status & logs
sudo systemctl status code-server@ubuntu.service
journalctl -u code-server@ubuntu.service
```

Setup code-server with [caddy and lets encrypt](https://github.com/cdr/code-server/blob/v3.8.0/doc/guide.md#lets-encrypt):

```
sudo apt install caddy
vim /etc/caddy/Caddyfile
sudo systemctl restart caddy.service
```
