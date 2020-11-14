# Docker Install Ubuntu

The Ubuntu repos have a `docker-ce` package but it isn't typically the latest version, so use the docker repo

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get install docker-ce docker-ce-cli containerd.io
```

Install using convenience script ([ref](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-convenience-script))

```
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker `whoami`
```
