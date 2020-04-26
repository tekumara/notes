# Docker Desktop for Mac

## Install

Install Docker Desktop, which uses its own hypervisor ([HyperKit](https://github.com/moby/hyperkit) based on xhyve):
```
brew cask install docker
```

Start docker from spotlight search - command+space - docker.
This starts docker and creates a symlink to the `docker` & `docker-compose` cli tools in `/usr/local/bin/docker`

Docker Desktop (and docker-for-mac) is more integrated and recommended than the older docker-machine (the new boot2docker) which is part of the docker toolbox and uses a Virtualbox VM running Linux. The Virtualbox VM has a separate IP address so you have to tell the Docker command line tools to talk to the VM using the docker-machine cli. It is installed via `brew install docker docker-compose`

https://stories.amazee.io/docker-on-mac-performance-docker-machine-vs-docker-for-mac-4c64c0afdf99
https://docs.docker.com/docker-for-mac/docker-toolbox/

## Installing the man pages

Desktop Desktop for mac doesn't install any manpages.

See https://github.com/cmosetick/docker-manpages-osx or

```
git clone https://github.com/docker/docker-ce.git
cd docker-ce
# checkout relevant version
git checkout 18.06
cd components/cli
make -f docker.Makefile manpages
echo "MANPATH $PWD/man" | sudo tee -a /private/etc/man.conf
```

## LinuxKit

Docker Desktop runs as a [LinuxKit](https://github.com/linuxkit/linuxkit) [HyperKit](https://github.com/moby/hyperkit) process. Because of this you won't see docker container processes in `ps`. To connect to the LinuxKit host, either
* the nsenter1 image (recommended): `docker run -it --rm --privileged --pid=host justincormack/nsenter1`
* screen: 
  ```
  screen ~/Library/Containers/com.docker.docker/Data/vms/0/tty
  ```
  NB: 
  * to exit, kill the screen (Ctrl-a k). If you detach (Ctrl-a d), make sure your reattach to the same screen. If you attach a second screen you'll get garbled text. Killing all sessions will resolve the issue, see [[Screen]]  
  * screen contains extra debug output that you probably don't need, scrollback doesn't work by default, and `less` doesn't use the whole screen. 

More info on both options [here](https://gist.github.com/BretFisher/5e1a0c7bcca4c735e716abf62afad389)

The Docker Desktop LinuxKit kernel is something like `4.9.93-linuxkit-aufs`. It is a custom built downstream from LinuxKit itself ([ref](https://github.com/docker/for-mac/issues/3050#issuecomment-402504883))

