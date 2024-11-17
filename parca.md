# parca

Install parca server:

```
sudo snap install parca
sudo snap start parca
```

Install agent:

```
sudo snap install --classic parca-agent
sudo snap set parca-agent remote-store-insecure=true
sudo snap set parca-agent remote-store-address=localhost:7070
sudo snap start parca-agent
```

https://www.parca.dev/docs/agent-server-snap-services
